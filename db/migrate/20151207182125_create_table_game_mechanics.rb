class CreateTableGameMechanics < ActiveRecord::Migration
  def change
    create_table :game_mechanics, id: false do |t|
      t.integer :game_id
      t.integer :mechanic_id
    end
  end
end
