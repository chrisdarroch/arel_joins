class School < ActiveRecord::Base
  belongs_to :region
  has_many :classrooms
end
