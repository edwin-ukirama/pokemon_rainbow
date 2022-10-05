class PokemonSkill < ApplicationRecord
  belongs_to :skill
  belongs_to :pokemon

  validates :current_pp, numericality: { greater_than_or_equal_to: 0 }
  validates :pokemon_id, presence: true
  validates :skill_id, uniqueness: { scope: :pokemon_id }, presence: true

  validate :validate_skill_count

  private
  def validate_skill_count
    if pokemon_id && PokemonSkill.where(pokemon_id: pokemon_id).count >= Pokemon::NUMBER_OF_ALLOWED_SKILLS
      errors.add(:pokemon_id, "Pokemon only allowed to have max 4 skills")
    end
  end
end
