class HomeController < ApplicationController
  def index
    @win_stat = PokemonStatistics.get_most_win_pokemon
    @lost_stat = PokemonStatistics.get_most_lost_pokemon
    @surrender_stat = PokemonStatistics.get_most_surrender_pokemon
    @most_picked = PokemonStatistics.get_most_picked_pokemon
  end
end
