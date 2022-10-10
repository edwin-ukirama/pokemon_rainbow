class CreatePokemonBattles < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemon_battles do |t|
      t.references :pokemon_1, null: false, foreign_key: { to_table: :pokemons }
      t.references :pokemon_2, null: false, foreign_key: { to_table: :pokemons }
      t.integer :current_turn, null: false, default: 1
      t.string :state, null: false, limit: 45
      t.references :pokemon_winner, foreign_key: { to_table: :pokemons }
      t.references :pokemon_loser, foreign_key: { to_table: :pokemons }
      t.integer :experience_gain
      t.integer :pokemon_1_max_health_point, null: false
      t.integer :pokemon_2_max_health_point, null: false
      t.timestamps
    end
  end
end
