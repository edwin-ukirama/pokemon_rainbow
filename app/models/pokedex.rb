class Pokedex < ApplicationRecord
  TYPES =  [
    "normal",
    "fighting",
    "flying",
    "poison",
    "ground",
    "rock",
    "bug",
    "ghost",
    "steel",
    "fire",
    "water",
    "grass",
    "electric",
    "psychic",
    "ice",
    "dragon",
    "dark",
    "fairy"
  ]

  validates :name, presence: true, uniqueness: true
  validates :health_point, presence: true
  validates :base_attack, presence: true
  validates :base_defense, presence: true
  validates :base_speed, presence: true
  validates :element_type, inclusion: { in: TYPES }, presence:true
  validates :image_url, presence: true, allow_blank: true
  validates :image_url, format: { with: URI.regexp, message: 'must be an url' }
end
