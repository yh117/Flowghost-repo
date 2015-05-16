class AddIdentifiableIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identifiable_id, :integer
  end
end
