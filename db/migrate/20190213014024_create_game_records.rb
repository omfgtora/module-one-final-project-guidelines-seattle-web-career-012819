class CreateGameRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :game_records do |t|
      t.references :game
      t.references :song
      t.integer :points

      t.timestamps      
    end
  end
end
