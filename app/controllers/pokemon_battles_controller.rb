class PokemonBattlesController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Pokemon Battle", :pokemon_battles_path
  def index
    @battles = PokemonBattle.page(params[:page])
  end

  def show
    @battle = PokemonBattle.find(params[:id])
    add_breadcrumb "Battle"
  end

  def new
    add_breadcrumb "Create Battle"
    @battle = PokemonBattle.new
    @pokemons = Pokemon.all
  end

  def create
    @battle = PokemonBattle.new(battle_params)
    @battle.state = PokemonBattle::ONGOING

    @battle.pokemon_1_id = battle_params[:pokemon_1_id]
    @battle.pokemon_2_id = battle_params[:pokemon_2_id]

    @battle.pokemon_1_max_health_point = @battle.pokemon_1.max_health_point
    @battle.pokemon_2_max_health_point = @battle.pokemon_2.max_health_point

    if @battle.save
      flash[:success] = "Battle Created!"
      redirect_to @battle
    else
      flash[:warning] = @battle.errors.full_messages
      @pokemons = Pokemon.all
      render :new, status: :unprocessable_entity
    end
  end

  def action_attack
    battle = PokemonBattle.find(params[:pokemon_battle_id])
    pokemon_skill = PokemonSkill.find(params[:skill_id])
    battle_engine = BattleEngine.new(battle)
    battle_engine.pokemon_skill = pokemon_skill

    if battle_engine.valid_next_turn?
      battle_engine.next_turn!(action: BattleEngine::ATTACK, pokemon_skill: pokemon_skill)
    end

    redirect_to battle
  end

  def surrender
    @battle = PokemonBattle.find(params[:pokemon_battle_id])
    battle_engine = BattleEngine.new(@battle)
    battle_engine.next_turn!(action: BattleEngine::SURRENDER)
    redirect_to @battle
  end

  private
  def battle_params
    params.require(:battle).permit(:pokemon_1_id, :pokemon_2_id)
  end
end
