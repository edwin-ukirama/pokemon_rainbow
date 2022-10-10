require 'json'
require 'csv'
require 'net/http'

namespace :pokemon_rainbow do
  desc "Drop DB and Seed data"
  task drop_and_seed: :environment do
    Rake::Task["db:migrate:reset"].invoke

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
    file = URI.open("https://docs.google.com/spreadsheets/d/e/2PACX-1vSXcic99Q0mwuJXCiEVfPKac_eJdsggRm3c6sEo1qZpAQc-aOqcMF0Na9s4utuUc39ZM-xnYVUG9sMh/pub?gid=0&single=true&output=csv") { |f| f.read }
    data = CSV.parse(file)
    keys = data.shift
    data.map! { |arr| Hash[keys.zip(arr)] }

    data.each do |skill_params|
      skill = Skill.new(skill_params)
      skill.save
    end

    pokedexes = Pokedex.all
    pokemon_ids = [133, 4]
    names = ["Geet", "Val"]

    pokemon_ids.each_with_index do |id, index|
      @pokedex = Pokedex.find(id)
      @pokemon = Pokemon.new(name: names[index])


      @pokemon.max_health_point = @pokedex.health_point
      @pokemon.current_health_point = @pokemon.max_health_point

      @pokemon.attack = @pokedex.base_attack
      @pokemon.defense = @pokedex.base_defense
      @pokemon.speed = @pokedex.base_speed

    end
  end
end
