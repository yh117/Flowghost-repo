class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
