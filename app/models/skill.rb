class Skill < ApplicationRecord
  has_many :pokemon_skill
  validates :name, presence: true, uniqueness: true
  validates :power, numericality: { greater_than: 0}
  validates :max_pp, numericality: { greater_than: 0}
  validates :element_type, inclusion: { in: Pokedex::TYPES}
end
