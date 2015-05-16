class RemoveNameFromInstructorUsers < ActiveRecord::Migration
  def change
    remove_column :instructor_users, :name, :string
  end
end
