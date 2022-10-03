class CreatePokedexes < ActiveRecord::Migration[7.0]
  def change
    create_table :pokedexes do |t|

      t.timestamps
    end
  end
end
