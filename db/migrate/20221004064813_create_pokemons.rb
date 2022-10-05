class CreatePokemons < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemons do |t|
      t.references :pokedex, null: false, foreign_key: { to_table: :pokedexes}
      t.string :name, index: { unique: true, name: 'unique_pokemon_names'}, limit: 45
      t.integer :level, null: false, default: 1
      t.integer :max_health_point, null: false
      t.integer :current_health_point, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :speed, null: false
      t.integer :current_experience, null: false, default: 0
      t.timestamps
    end
  end
end
