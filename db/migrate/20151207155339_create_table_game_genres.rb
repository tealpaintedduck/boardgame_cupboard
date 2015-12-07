class CreateTableGameGenres < ActiveRecord::Migration
  def change
    create_table :game_genres, id: false do |t|
      t.integer :game_id
      t.integer :genre_id
    end
  end
end
