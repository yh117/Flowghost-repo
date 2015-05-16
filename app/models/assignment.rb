class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :tag_assignments, dependent: :destroy
  has_many :tags, through: :tag_assignments
  
  #commented out by ajax
  #accepts_nested_attributes_for :tags #TODO see if this make the course save info
  has_many :grades

  #commented out by ajax
  #before_save :get_tags

  #commented out by ajax
#  def get_tags
#    self.tags = self.tags.collect do |tag|
#      Tag.find_or_create_by(:name=>tag.name, :course_id=>self.course.id)
#    end
#  end
end
