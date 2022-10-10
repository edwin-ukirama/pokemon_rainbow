module ApplicationHelper
  def calculate_hp_percentage(pokemon)
    pokemon.current_health_point.to_f/pokemon.max_health_point * 100
  end

  def get_bg_color(pokemon)
    hp_percentage = calculate_hp_percentage(pokemon)
    if hp_percentage <= 25
      "bg-danger"
    elsif hp_percentage <=50
      "bg-warning"
    else
      "bg-success"
    end
  end

  def get_cap_exp(level)
    2 ** level * 100
  end

  def calculate_exp_percentage(current_exp, level)
    current_exp.to_f / (2 ** level * 100) * 100
  end
end
