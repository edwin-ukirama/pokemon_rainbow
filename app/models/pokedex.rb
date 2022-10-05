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
  validates :health_point, numericality: { greater_than: 0}
  validates :base_attack, numericality: { greater_than: 0}
  validates :base_defense, numericality: { greater_than: 0}
  validates :base_speed, numericality: { greater_than: 0}
  validates :element_type, inclusion: { in: TYPES }, presence:true
  validates :image_url, presence: true, allow_blank: true
  validates :image_url, format: { with: URI.regexp, message: 'must be an url' }
end
