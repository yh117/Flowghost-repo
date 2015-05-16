class CreateStudentEmails < ActiveRecord::Migration
  def change
    create_table :student_emails do |t|
      t.string :email
      t.integer :course_id
      t.string :random_url
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
