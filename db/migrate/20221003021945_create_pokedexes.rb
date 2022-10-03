class CreatePokedexes < ActiveRecord::Migration[7.0]
  def change
    create_table :pokedexes do |t|
      t.string :name, index: { unique: true, name: 'unique_names'}, limit: 45
      t.integer :health_point
      t.integer :base_attack
      t.integer :base_defense
      t.integer :base_speed
      t.string :element_type
      t.string :image_url
      t.timestamps
    end
  end
end
