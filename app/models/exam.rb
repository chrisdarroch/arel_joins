class Exam < ActiveRecord::Base
  has_many :results
  has_many :students, :as => :attendees, :through => :results
end
