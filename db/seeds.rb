# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
states = State.create([{ :name => "NSW", :name => "QLD"}])

regions = {}
regions[:newcastle] = Region.create(:name => "Newcastle", :state => states.first)

schools = {}
schools[:merewether] = School.create(:name => "Merewether High School", :region => regions[:newcastle])

classrooms = {}
classrooms[:a] = Classroom.create(:name => "Class A", :school => schools[:merewether])
