# frozen_string_literal: true
class BattleEngine
  attr_accessor :battle, :pokemons, :pokemon_skill

  ATTACK = :attack
  SURRENDER = :surrender

  def initialize(pokemon_battle)
    @battle = pokemon_battle
    @pokemons = [pokemon_battle.pokemon_1, pokemon_battle.pokemon_2]
    @winner = nil
  end

  def pokemons_alive?
    @pokemons.reduce(true) { |result, pokemon| pokemon.current_health_point > 0 && result }
  end

  def skill_available?
    @pokemon_skill.current_pp > 0
  end

  def battle_ongoing?
    @battle.state.eql?(PokemonBattle::ONGOING)
  end

  def valid_next_turn?
    # unless pokemons_alive?
    #   flash[:error] = "One of the pokemon is fainted"
    # end

    # unless skill_available?
    #   flash[:error] = "The selected skill has no pp left"
    # end

    # unless battle_ongoing?
    #   flash[:error] = "The battle already ended"
    # end

    pokemons_alive? && skill_available? && battle_ongoing?
  end


  def next_turn!(action:, pokemon_skill:nil)
    case action
    when ATTACK
      attack pokemon_skill
    when SURRENDER
      surrender
    end
  end

  def multiplier_message(multiplier)
    if multiplier.eql? 0
      return "No effect!"
   elsif multiplier.eql? 0.5
      return "Not very effective!"
   elsif multiplier.eql? 2
      return "Super-effective!"
   end
  end

  def attack(pokemon_skill)
    if @battle.current_turn.odd?
      attacker = @pokemons[0]
      defender = @pokemons[1]
    else
      attacker = @pokemons[1]
      defender = @pokemons[0]
    end

    damage = PokemonBattleCalculator.calculate_damage(attacker, defender, pokemon_skill.skill)

    battle_log = PokemonBattleLog.new
    battle_log.pokemon_battle_id = @battle.id
    battle_log.attacker_id = attacker.id
    battle_log.defender_id = defender.id
    battle_log.skill_id = pokemon_skill.skill_id
    battle_log.damage = damage
    battle_log.turn = @battle.current_turn
    battle_log.action_type = PokemonBattleLog::ATTACK

    type_multiplier = PokemonBattleCalculator.calculate_type_multiplier(pokemon_skill.skill.element_type, defender.pokedex.element_type)
    multiplier_message = multiplier_message(type_multiplier)
    battle_log.message = "#{attacker.name} used #{pokemon_skill.skill.name.titleize}! \n #{multiplier_message}"


    if damage >= defender.current_health_point
      defender.current_health_point = 0
    else
      defender.current_health_point -= damage
    end

    battle_log.attacker_current_health_point = attacker.current_health_point
    battle_log.defender_current_health_point = defender.current_health_point

    @battle.current_turn = @battle.current_turn + 1
    pokemon_skill.current_pp = pokemon_skill.current_pp -  1
    pokemon_skill.save

    battle_log.save

    save!
  end

  def surrender
    if @battle.state.eql? PokemonBattle::FINISHED
      # flash[:warning] = "Cannot surrender on finished battle"
      return
    end

    battle_log = PokemonBattleLog.new
    battle_log.pokemon_battle_id = @battle.id
    battle_log.action_type = PokemonBattleLog::SURRENDER
    battle_log.turn = @battle.current_turn
    battle_log.damage = 0

    if @battle.current_turn.odd?
      finish(winner: @battle.pokemon_2, loser: @battle.pokemon_1)
      battle_log.attacker_id = @battle.pokemon_1.id
      battle_log.defender_id = @battle.pokemon_2.id
    else
      finish(winner: @battle.pokemon_1, loser: @battle.pokemon_2)
      battle_log.attacker_id = @battle.pokemon_2.id
      battle_log.defender_id = @battle.pokemon_1.id
    end

    battle_log.message = "#{battle_log.attacker.name} surrender!"

    battle_log.attacker_current_health_point = battle_log.attacker.current_health_point
    battle_log.defender_current_health_point = battle_log.defender.current_health_point

    battle_log.save
    save!
  end


  def finish(winner:, loser:)
    @battle.pokemon_winner_id = winner.id
    @battle.pokemon_loser_id = loser.id

    @battle.state = PokemonBattle::FINISHED
    exp = PokemonBattleCalculator.calculate_experience(loser.level)
    @battle.experience_gain = exp
    winner.current_experience += exp

    while PokemonBattleCalculator.level_up?(winner)
      cap_exp = 2** winner.level * 100
      winner.level += 1
      winner.current_experience -= cap_exp
      bonus_stats = PokemonBattleCalculator.calculate_level_up_extra_stats
      winner.max_health_point += bonus_stats.health_point
      winner.attack += bonus_stats.attack_point
      winner.defense += bonus_stats.defense_point
      winner.speed += bonus_stats.speed_point
    end

  end

  def save!
    if @battle.pokemon_1.current_health_point.eql? 0
      finish(winner: @battle.pokemon_2, loser: @battle.pokemon_1)
    elsif @battle.pokemon_2.current_health_point.eql? 0
      finish(winner: @battle.pokemon_1, loser: @battle.pokemon_2)
    end
    @battle.save
    @pokemons.each do |pokemon|
      pokemon.save
    end
  end
end
