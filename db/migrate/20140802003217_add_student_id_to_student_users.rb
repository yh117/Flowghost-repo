class AddStudentIdToStudentUsers < ActiveRecord::Migration
  def change
    add_column :student_users, :student_id, :integer
  end
end
