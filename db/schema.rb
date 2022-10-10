# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_10_042453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pokedexes", force: :cascade do |t|
    t.string "name", limit: 45
    t.integer "health_point"
    t.integer "base_attack"
    t.integer "base_defense"
    t.integer "base_speed"
    t.string "element_type"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_names", unique: true
  end

  create_table "pokemon_battle_logs", force: :cascade do |t|
    t.bigint "pokemon_battle_id", null: false
    t.integer "turn"
    t.bigint "skill_id"
    t.string "message"
    t.integer "damage"
    t.bigint "attacker_id", null: false
    t.integer "attacker_current_health_point"
    t.bigint "defender_id", null: false
    t.integer "defender_current_health_point"
    t.string "action_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attacker_id"], name: "index_pokemon_battle_logs_on_attacker_id"
    t.index ["defender_id"], name: "index_pokemon_battle_logs_on_defender_id"
    t.index ["pokemon_battle_id"], name: "index_pokemon_battle_logs_on_pokemon_battle_id"
    t.index ["skill_id"], name: "index_pokemon_battle_logs_on_skill_id"
  end

  create_table "pokemon_battles", force: :cascade do |t|
    t.bigint "pokemon_1_id", null: false
    t.bigint "pokemon_2_id", null: false
    t.integer "current_turn", default: 1, null: false
    t.string "state", limit: 45, null: false
    t.bigint "pokemon_winner_id"
    t.bigint "pokemon_loser_id"
    t.integer "experience_gain"
    t.integer "pokemon_1_max_health_point", null: false
    t.integer "pokemon_2_max_health_point", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_1_id"], name: "index_pokemon_battles_on_pokemon_1_id"
    t.index ["pokemon_2_id"], name: "index_pokemon_battles_on_pokemon_2_id"
    t.index ["pokemon_loser_id"], name: "index_pokemon_battles_on_pokemon_loser_id"
    t.index ["pokemon_winner_id"], name: "index_pokemon_battles_on_pokemon_winner_id"
  end

  create_table "pokemon_skills", force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "pokemon_id", null: false
    t.integer "current_pp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id"], name: "index_pokemon_skills_on_pokemon_id"
    t.index ["skill_id"], name: "index_pokemon_skills_on_skill_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.bigint "pokedex_id", null: false
    t.string "name", limit: 45
    t.integer "level", default: 1, null: false
    t.integer "max_health_point", null: false
    t.integer "current_health_point", null: false
    t.integer "attack", null: false
    t.integer "defense", null: false
    t.integer "speed", null: false
    t.integer "current_experience", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_pokemon_names", unique: true
    t.index ["pokedex_id"], name: "index_pokemons_on_pokedex_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", limit: 45
    t.integer "power"
    t.integer "max_pp"
    t.string "element_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "unique_skill_names", unique: true
  end

  add_foreign_key "pokemon_battle_logs", "pokemon_battles"
  add_foreign_key "pokemon_battle_logs", "pokemons", column: "attacker_id"
  add_foreign_key "pokemon_battle_logs", "pokemons", column: "defender_id"
  add_foreign_key "pokemon_battle_logs", "skills"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_1_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_2_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_loser_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_winner_id"
  add_foreign_key "pokemon_skills", "pokemons"
  add_foreign_key "pokemon_skills", "skills"
  add_foreign_key "pokemons", "pokedexes"
end
