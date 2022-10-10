class PokemonBattleLogsController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Battle Logs", :pokemon_battle_logs_path

  def index
    @battles = PokemonBattle.all
  end

  def show
    add_breadcrumb "Detail"
    @battle = PokemonBattle.find(params[:id])
    @logs = @battle.battle_logs
  end
end
