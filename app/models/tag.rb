class Tag < ActiveRecord::Base
  belongs_to :course
  has_many :tag_assignments, dependent: :destroy
  has_many :assignments, through: :tag_assignments, foreign_key: :course_id #not sure i made the right merge-conflict choice lol #TODO TESTING
end
