class User < ActiveRecord::Base

  before_save { self.email = email.downcase }

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password,  presence: true, length: { minimum: 6 }
  validates :password,  presence: true
  has_many :courses

  # polymorphic association
  belongs_to :identifiable, polymorphic: true
  #has_one :student_user, :as => :identifiable
  #has_one :instructor_user, :as => :identifiable

end
