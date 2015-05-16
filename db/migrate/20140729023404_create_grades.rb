class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :student_id
      t.integer :points
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :assignment_id
    end
  end
end
