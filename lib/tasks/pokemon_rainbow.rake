require 'json'
require 'net/http'

namespace :pokemon_rainbow do
  desc "Import pokedex data from pokedex.json on github"
  task import_pokedex: :environment do
    uri = URI('https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/pokedex.json'){ |f| f.read}
    data = Net::HTTP.get(uri)

    data_hash = JSON.parse(data)
    new_data_arr = []
    data_hash.each do |data|
      new_data = Hash.new
      new_data[:name] = data["name"]["english"]
      new_data[:health_point] = data["base"]["HP"]
      new_data[:base_attack] = data["base"]["Attack"]
      new_data[:base_defense] = data["base"]["Defense"]
      new_data[:base_speed] = data["base"]["Speed"]
      new_data[:element_type] = data["type"][0].downcase
      new_data[:image_url] = "0"

      pokedex = Pokedex.new(new_data)
      pokedex.save
    end
  end
end
