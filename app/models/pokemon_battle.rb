# frozen_string_literal: true
class PokemonBattle < ApplicationRecord
  ONGOING = "ongoing".freeze
  FINISHED = "finished".freeze
  STATE = [
    ONGOING,
    FINISHED
  ]

  scope :ongoing, -> { where(state: ONGOING) }
  scope :finished, -> { where(state: FINISHED) }

  scope :pokemon_ongoing_battle, -> (pokemon_id) { ongoing.where("pokemon_1_id = ? OR pokemon_2_id = ?", pokemon_id, pokemon_id) }

  has_many :battle_logs, class_name: "PokemonBattleLog", foreign_key: :pokemon_battle_id, dependent: :delete_all

  belongs_to :pokemon_1, class_name: "Pokemon", foreign_key: :pokemon_1_id
  belongs_to :pokemon_2, class_name: "Pokemon", foreign_key: :pokemon_2_id

  belongs_to :winner, class_name: "Pokemon", foreign_key: :pokemon_winner_id, optional: true
  belongs_to :loser, class_name: "Pokemon", foreign_key: :pokemon_loser_id, optional: true

  validates :state, inclusion: { in: STATE }, presence: true
  validates :pokemon_1_id, presence: true
  # validates :pokemon_2_id, uniqueness: { scope: :pokemon_1_id }, presence: true
  validates :pokemon_1_max_health_point, numericality: { greater_than: 0 }
  validates :pokemon_2_max_health_point, numericality: { greater_than: 0 }
  validates :pokemon_1_id, comparison: { other_than: :pokemon_2_id, message: "cannot be the same as Pokemon 2" }
  # validates :pokemon_2_id, comparison: { other_than: :pokemon_1_id, message: "cannot be the same as Pokemon 1" }

  validate :pokemon_must_be_alive, on: :create
  validate :pokemon_must_not_have_ongoing_battle, on: :create
  validate :pokemon_must_have_skill, on: :create

  def pokemon_must_not_have_ongoing_battle
    ongoing_battles = PokemonBattle.ongoing

    errors.add(:pokemon_1_id, "Pokemon 1 still on battle") if ongoing_battles.select { |battle| battle.pokemon_1_id.eql?(pokemon_1_id) }.count > 1
    errors.add(:pokemon_2_id, "Pokemon 2 still on battle") if ongoing_battles.select { |battle| battle.pokemon_2_id.eql?(pokemon_2_id) }.count > 1

  end

  def pokemon_must_be_alive
    if pokemon_1_id.present? && pokemon_2_id.present?
      errors.add(:pokemon_1, "Pokemon must be alive to battle!") if pokemon_1.current_health_point == 0
      errors.add(:pokemon_2, "Pokemon must be alive to battle!") if pokemon_2.current_health_point == 0
    end
  end

  def pokemon_must_have_skill
    if pokemon_1_id.present? && pokemon_2_id.present?
      errors.add(:pokemon_1, "Pokemon must have skill(s) to battle!") if pokemon_1.pokemon_skills.count == 0
      errors.add(:pokemon_2, "Pokemon must have skill(s) to battle!") if pokemon_2.pokemon_skills.count == 0
    end
  end

end
