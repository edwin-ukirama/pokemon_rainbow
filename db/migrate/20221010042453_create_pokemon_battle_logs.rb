class CreatePokemonBattleLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemon_battle_logs do |t|
      t.references :pokemon_battle, null: false, foreign_key: true
      t.integer :turn
      t.references :skill, foreign_key: true
      t.string :message, null: true
      t.integer :damage, null: true
      t.references :attacker, null: false, foreign_key: { to_table: :pokemons }
      t.integer :attacker_current_health_point
      t.references :defender, null: false, foreign_key: { to_table: :pokemons }
      t.integer :defender_current_health_point
      t.string :action_type

      t.timestamps
    end
  end
end
