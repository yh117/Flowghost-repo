class Student < ActiveRecord::Base

  belongs_to :course
  has_many :grades, dependent: :destroy
  before_create :set_hash

  belongs_to :student_user

  def set_hash 
    self.random_url = SecureRandom.hex
    logger.info "%%%%%%%%%% Student set_hash: randon_url is "+self.random_url
  end

end
