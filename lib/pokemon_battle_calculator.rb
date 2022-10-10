class PokemonBattleCalculator
  def self.calculate_damage(attacker, defender, skill)
    stab = attacker.pokedex.element_type == skill.element_type ? 1.5 : 1

    wr = calculate_type_multiplier(skill.element_type,defender.pokedex.element_type)

    random_number = rand(85..100)

    damage = ((((2.0 * attacker.level/5.0) + 2) * attacker.attack * skill.power / defender.defense/50.0) + 2) * stab * wr * (random_number/100.0)
    return damage.to_i
  end

  def self.calculate_type_multiplier(skill_type, target_type)
    types = JSON.parse(File.read("#{Rails.root}/lib/assets/type-chart.json"))
    types[skill_type][target_type]
  end

  def self.calculate_experience(enemy_level)
    random_number = rand(20..150)
    experience_gain = random_number * enemy_level
    experience_gain
  end

  def self.level_up?(winner)
    2 ** winner.level * 100 <= winner.current_experience
  end


  BonusStats = Struct.new(:health_point, :attack_point, :defense_point, :speed_point)
  def self.calculate_level_up_extra_stats
    bonus_stats = BonusStats.new
    bonus_stats.health_point = rand(10..20)
    bonus_stats.attack_point = rand(1..5)
    bonus_stats.defense_point = rand(1..5)
    bonus_stats.speed_point = rand(1..5)
    bonus_stats
  end

end
