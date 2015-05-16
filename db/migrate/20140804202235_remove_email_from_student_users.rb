class RemoveEmailFromStudentUsers < ActiveRecord::Migration
  def change
    remove_column :student_users, :email, :string
  end
end
