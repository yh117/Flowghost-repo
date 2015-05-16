class RemoveIdentifiableIdFromStudentUsers < ActiveRecord::Migration
  def change
    remove_column :student_users, :identifiable_id, :integer
  end
end
