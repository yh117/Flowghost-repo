class RemoveNameFromStudentUsers < ActiveRecord::Migration
  def change
    remove_column :student_users, :name, :string
  end
end
