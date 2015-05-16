class RemovePasswordDigestFromStudentUsers < ActiveRecord::Migration
  def change
    remove_column :student_users, :password_digest, :string
  end
end
