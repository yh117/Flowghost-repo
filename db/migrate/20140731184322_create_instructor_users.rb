class CreateInstructorUsers < ActiveRecord::Migration
  def change
    create_table :instructor_users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
