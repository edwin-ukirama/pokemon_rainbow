class Pokemon < ApplicationRecord
  NUMBER_OF_ALLOWED_SKILLS = 4

  belongs_to :pokedex
  has_many :pokemon_skills, dependent: :delete_all
  has_many :skills, through: :pokemon_skills
  has_many :battle_won, class_name: "PokemonBattle", foreign_key: :pokemon_winner_id
  has_many :battle_lose, class_name: "PokemonBattle", foreign_key: :pokemon_loser_id

  validates :name, presence: true, uniqueness: { message: "Pokemon already exist in your dex"}
  validates :max_health_point, numericality: { greater_than: 0 }, presence: true
  validates :current_health_point, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max_health_point }, presence: true
  validates :attack, numericality: { greater_than: 0 }, presence: true
  validates :defense, numericality: { greater_than: 0 }, presence: true
  validates :speed, numericality: { greater_than: 0 }, presence: true
  validates :level, numericality: { greater_than: 0 }, presence: true
  validates :current_experience, numericality: { greater_than_or_equal_to: 0 }, presence: true

  def battles
    PokemonBattle.where("pokemon_1_id  = ? OR pokemon_2_id = ?", self.id, self.id)
  end
end
