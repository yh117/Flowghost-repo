class AddStudentUserIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :student_user_id, :integer
  end
end
