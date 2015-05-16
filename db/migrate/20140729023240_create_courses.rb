class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :user_id
    end
  end
end
