require File.dirname(__FILE__) + '/../spec_helper'

describe "Joins" do
  before do
    @regions = Region.arel_table
    @schools = School.arel_table
    @classrooms = Classroom.arel_table
    @students = Student.arel_table

    @exams = Exam.arel_table
    @results = Result.arel_table
  end
  
  it "allows you to join multiple tables" do
    query = @students \
      .join(@classrooms).on(@students[:classroom_id].eq(@classrooms[:id])) \
      .join(@schools).on(@classrooms[:school_id].eq(@schools[:id])) \
      .join(@regions).on(@schools[:region_id].eq(@regions[:id]))
    
    join_string = "FROM       \"students\" INNER JOIN \"classrooms\" ON \"students\".\"classroom_id\" = \"classrooms\".\"id\" INNER JOIN \"schools\" ON \"classrooms\".\"school_id\" = \"schools\".\"id\" INNER JOIN \"regions\" ON \"schools\".\"region_id\" = \"regions\".\"id\""

    query.project(@students[:first_name], @regions[:name]).to_sql.should == "SELECT     \"students\".\"first_name\", \"regions\".\"name\"" + " " + join_string
  end
  
  context "exam results" do
    before(:each) do
      @query = @results.project(@results[:mark].sum.as(:totals)).join(@students).on(@results[:student_id].eq(@students[:id]))
    end
    
    it "closes over aggregations transparently" do
      @query \
        .to_sql.should == "SELECT     \"results_external\".\"totals\", \"students\".\"id\", \"students\".\"classroom_id\", \"students\".\"identification\", \"students\".\"first_name\", \"students\".\"last_name\", \"students\".\"created_at\", \"students\".\"updated_at\" FROM       (SELECT     SUM(\"results\".\"mark\") AS \"totals\" FROM       \"results\") \"results_external\" INNER JOIN \"students\" ON \"results\".\"student_id\" = \"students\".\"id\""
    end
    
    it "can project fields from derived relations" do
      @query.project(@students[:first_name], @students[:classroom_id], @query[:totals]) \
        .to_sql.should == "SELECT     \"students\".\"first_name\", \"students\".\"classroom_id\", \"results_external\".\"totals\" FROM       (SELECT     SUM(\"results\".\"mark\") AS \"totals\" FROM       \"results\") \"results_external\" INNER JOIN \"students\" ON \"results\".\"student_id\" = \"students\".\"id\""
    end

    # The first problem
    it "joins across special relations" do
      @complex = @query.join(@classrooms).on(@students[:classroom_id].eq(@classrooms[:id]))
      @complex \
        .to_sql.should == "stuff"
    end
  
    # The second problem
    it "projects across compounded relations" do
      sql = []
      sql << "SELECT     \"students\".\"first_name\", \"classrooms\".\"name\", \"results_external\".\"totals\""
      sql << " FROM       ("
      sql << "SELECT     SUM(\"results\".\"mark\") AS \"totals\" FROM       \"results\""
      sql << ") \"results_external\""
      sql << " INNER JOIN \"students\" ON \"results\".\"student_id\" = \"students\".\"id\""
      sql << " INNER JOIN \"classrooms\" ON \"students\".\"classroom_id\" = \"classrooms\".\"id\""
      sql = sql.join("")

      @complex = @query.join(@classrooms).on(@students[:classroom_id].eq(@classrooms[:id]))
      @complex \
        .project(@students[:first_name], @classrooms[:name], @query[:totals]) \
        .to_sql.should == sql
    end
  end
end