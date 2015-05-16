class TagAssignment < ActiveRecord::Base
     belongs_to :assignment
  belongs_to :tag
  belongs_to :course
end
