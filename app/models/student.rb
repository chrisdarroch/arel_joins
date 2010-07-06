class Student < ActiveRecord::Base
  belongs_to :classroom
  
  has_many :results
  has_many :exams, :through => :results
end
