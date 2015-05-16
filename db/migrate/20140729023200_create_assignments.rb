class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.integer :course_id
      t.integer :points_possible
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :points
      t.string :tagnames
    end
  end
end
