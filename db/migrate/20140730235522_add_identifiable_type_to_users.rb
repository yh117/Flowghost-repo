class AddIdentifiableTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identifiable_type, :string
  end
end
