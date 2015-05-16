class CreateCsvmngrs < ActiveRecord::Migration
  def change
    create_table :csvmngrs do |t|
      t.string :instructor
      t.string :email
      t.integer :courseid
      t.string :filename

      t.timestamps
    end
  end
end
