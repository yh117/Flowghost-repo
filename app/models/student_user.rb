class StudentUser < ActiveRecord::Base

  #polymorphic association
  has_one :user, as: :identifiable, dependent: :destroy
  accepts_nested_attributes_for :user

  has_one :student, dependent: :destroy
  #accepts_nested_attributes_for :student

end

