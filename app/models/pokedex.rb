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
  validates :element_type, inclusion: { in: TYPES }
end
