class RemoveEmailFromInstructorUsers < ActiveRecord::Migration
  def change
    remove_column :instructor_users, :email, :string
  end
end
