require 'json'
require 'csv'
require 'net/http'

namespace :pokemon_rainbow do
  desc "Import pokedex data from pokedex.json on github"
  task import_pokedex: :environment do
    uri = URI('https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/pokedex.json'){ |f| f.read}
    data = Net::HTTP.get(uri)

    data_hash = JSON.parse(data)
    data_hash.each_with_index do |data, index|
      new_data = Hash.new
      new_data[:name] = data["name"]["english"]
      new_data[:health_point] = data["base"]["HP"]
      new_data[:base_attack] = data["base"]["Attack"]
      new_data[:base_defense] = data["base"]["Defense"]
      new_data[:base_speed] = data["base"]["Speed"]
      new_data[:element_type] = data["type"][0].downcase
      new_data[:image_url] = "https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/#{data["id"].to_s.rjust(3,'0')}.png"

      pokedex = Pokedex.new(new_data)
      pokedex.save
    end
  end

  task import_skills: :environment do
    file = URI.open("https://docs.google.com/spreadsheets/d/e/2PACX-1vSXcic99Q0mwuJXCiEVfPKac_eJdsggRm3c6sEo1qZpAQc-aOqcMF0Na9s4utuUc39ZM-xnYVUG9sMh/pub?gid=0&single=true&output=csv") { |f| f.read }
    data = CSV.parse(file)
    keys = data.shift
    data.map! { |arr| Hash[keys.zip(arr)] }

    data.each do |skill_params|
      skill = Skill.new(skill_params)
      skill.save
    end
  end

  task import_evolutions: :environment do

  end
end
