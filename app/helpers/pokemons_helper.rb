module PokemonsHelper
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
end
