class AddIdentifiableTypeToStudentUsers < ActiveRecord::Migration
  def change
    add_column :student_users, :identifiable_type, :string
  end
end
