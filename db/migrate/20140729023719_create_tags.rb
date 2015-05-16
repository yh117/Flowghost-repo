class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :course_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string :assignmentnames
    end
  end
end
