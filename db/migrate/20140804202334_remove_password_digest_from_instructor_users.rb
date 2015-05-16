class RemovePasswordDigestFromInstructorUsers < ActiveRecord::Migration
  def change
    remove_column :instructor_users, :password_digest, :string
  end
end
