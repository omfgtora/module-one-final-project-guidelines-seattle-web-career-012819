class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :title
      t.date :release_date
      t.text :lyrics

      t.timestamps
    end
  end
end
