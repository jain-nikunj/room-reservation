class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :number
      t.integer :capacity
      t.references :building, index: true, foreign_key: true
      t.text :facilities
      t.text :misc

      t.timestamps null: false
    end
  end
end
