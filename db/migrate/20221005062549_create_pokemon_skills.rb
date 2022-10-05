class CreatePokemonSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :pokemon_skills do |t|
      t.references :skill, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true
      t.integer :current_pp

      t.timestamps
    end
  end
end
