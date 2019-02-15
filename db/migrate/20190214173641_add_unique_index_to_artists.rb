class AddUniqueIndexToArtists < ActiveRecord::Migration[5.2]
  def change
    add_index :artists, :name, unique: true
  end
end
