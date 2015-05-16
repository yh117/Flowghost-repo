class InstructorUser < ActiveRecord::Base

  #polymorphic association
  has_one :user, as: :identifiable, dependent: :destroy
  accepts_nested_attributes_for :user

  #belongs_to :identifiable, :polymorphic => true


end

