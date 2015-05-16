class Course < ActiveRecord::Base
	belongs_to :user
	has_many :assignments, dependent: :destroy
	has_many :students, dependent: :destroy
    has_many :tags, dependent: :destroy
#commented out by ajax
accepts_nested_attributes_for :assignments, :tags, :students #TODO SEE IF THIS MAKES THE COURSE SAVE INFO
    has_many :tag_assignments, dependent: :destroy #added by ajax
end
