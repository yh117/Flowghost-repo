class RemoveIdentifiableTypeFromStudentUsers < ActiveRecord::Migration
  def change
    remove_column :student_users, :identifiable_type, :string
  end
end
