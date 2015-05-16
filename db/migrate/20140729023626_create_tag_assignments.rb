class CreateTagAssignments < ActiveRecord::Migration
  def change
    create_table :tag_assignments do |t|
      t.integer :assignment_id
      t.integer :tag_id
      t.integer :course_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
