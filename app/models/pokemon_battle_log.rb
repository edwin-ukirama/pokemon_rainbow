# frozen_string_literal: true
class PokemonBattleLog < ApplicationRecord
  ATTACK = "attack"
  SURRENDER = "surrender"

  ACTION_TYPES = [
    ATTACK,
    SURRENDER
  ]


  belongs_to :pokemon_battle
  belongs_to :skill, optional: true
  belongs_to :attacker, class_name: "Pokemon", foreign_key: :attacker_id
  belongs_to :defender, class_name: "Pokemon", foreign_key: :defender_id

  validates :action_type, inclusion: { in: ACTION_TYPES }
end
