class AddIdentifiableIdToStudentUsers < ActiveRecord::Migration
  def change
    add_column :student_users, :identifiable_id, :integer
  end
end
