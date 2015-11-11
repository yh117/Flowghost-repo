class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string   :email
      t.integer  :course_id
      t.string   :random_url
      t.integer  :student_user_id
    end
  end
end
