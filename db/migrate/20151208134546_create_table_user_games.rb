class CreateTableUserGames < ActiveRecord::Migration
  def change
    create_table :user_games, id: false do |t|
      t.integer :user_id
      t.integer :game_id
    end
  end
end
