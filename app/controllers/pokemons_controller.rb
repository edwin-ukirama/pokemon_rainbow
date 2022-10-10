require 'pry'
class PokemonsController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Pokemon", :pokemons_path
  def index
    @pokemons = Pokemon.all
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @skills = Skill.where(element_type: [@pokemon.pokedex.element_type, "normal"])
          .where.not(id: @pokemon.skills.ids)
    add_breadcrumb "#{@pokemon.name}"
  end

  def new
    add_breadcrumb "Create Pokemon"
    @pokemon = Pokemon.new
    @pokedexes = Pokedex.all
  end

  def create
    @pokedexes = Pokedex.all

    @pokedex = Pokedex.find(pokemon_params[:pokedex_id])
    @pokemon = Pokemon.new(pokemon_params)

    @pokemon.max_health_point = @pokedex.health_point
    @pokemon.current_health_point = @pokemon.max_health_point

    @pokemon.attack = @pokedex.base_attack
    @pokemon.defense = @pokedex.base_defense
    @pokemon.speed = @pokedex.base_speed

    if @pokemon.save
      flash[:success] = "Pokemon has been created!"
      redirect_to @pokemon
    else
      flash[:error] = @pokemon.errors["name"]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
    @skills = Skill.where(element_type: [@pokemon.pokedex.element_type, "normal"])
    .where.not(id: @pokemon.skills.ids)
    add_breadcrumb "#{@pokemon.name}"
    add_breadcrumb "Edit"
  end

  def update
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.update(pokemon_params)
      flash[:success] = "Pokemon has been updated!"
      redirect_to @pokemon
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pokemon = Pokemon.find(params[:id])
    @pokemon.destroy

    flash[:success] = "Pokemon has been removed!"

    redirect_to pokemons_path
  end

  def heal
    pokemon = Pokemon.find(params[:pokemon_id])

    pokemon_ongoing_battle_count = PokemonBattle.pokemon_ongoing_battle(params[:pokemon_id]).count
    if pokemon_ongoing_battle_count > 0
      flash[:warning] = "Can't heal pokemon that still on a battle"
      redirect_to pokemon
      return
    end

    pokemon.current_health_point = pokemon.max_health_point
    pokemon.pokemon_skills.each do |ref|
      ref.current_pp = ref.skill.max_pp
      ref.save
    end
    pokemon.save

    flash[:success] = "#{pokemon.name} has been healed!"

    redirect_to pokemon
  end

  def heal_all
    pokemons_in_battle_ids = PokemonBattle.ongoing.pluck(:pokemon_1_id, :pokemon_2_id).flatten
    pokemons = Pokemon.where.not(id: pokemons_in_battle_ids)
    pokemons.each do |pokemon|
      pokemon.current_health_point = pokemon.max_health_point
      pokemon.pokemon_skills.each do |ref|
        ref.current_pp = ref.skill.max_pp
        ref.save
      end
      pokemon.save
    end

    flash[:success] = "All Pokemon has been healed!"
    redirect_to pokemons_path
  end

  def add_skill
    pokemon = Pokemon.find(params[:pokemon_id])

    pokemon_ongoing_battle_count = PokemonBattle.pokemon_ongoing_battle(params[:pokemon_id]).count
    if pokemon_ongoing_battle_count > 0
      flash[:warning] = "Can't refill pp on pokemon that still on a battle"
      redirect_to pokemon
      return
    end

    skill = Skill.find(params[:skill_id])
    pokemon_skill = PokemonSkill.new
    pokemon_skill.pokemon_id = pokemon.id
    pokemon_skill.skill_id = skill.id
    pokemon_skill.current_pp = skill.max_pp

    if pokemon_skill.save
      flash[:success] = "#{skill.name.titleize} added!"
    else
      flash[:error] = "One pokemon only allowed to have 4 skills maximum!"
    end

    redirect_to pokemon
  end

  def refill_skill_pp
    pokemon = Pokemon.find(params[:pokemon_id])

    pokemon_ongoing_battle_count = PokemonBattle.pokemon_ongoing_battle(params[:pokemon_id]).count
    if pokemon_ongoing_battle_count > 0
      flash[:warning] = "Can't refill pp on pokemon that still on a battle"
      redirect_to pokemon
      return
    end

    pokemon_skill = pokemon.pokemon_skills.find(params[:skill_id])
    pokemon_skill.current_pp = pokemon_skill.skill.max_pp

    if pokemon_skill.save
      flash[:success] = "#{pokemon_skill.skill.name.titleize} pp has been refilled!"
      redirect_to edit_pokemon_path(pokemon)
    else
      flash[:error] = "#{pokemon_skill.errors}"
      redirect_to edit_pokemon_path(pokemon), status: :unprocessable_entity
    end
  end

  def remove_skill
    pokemon = Pokemon.find(params[:pokemon_id])

    pokemon_ongoing_battle_count = PokemonBattle.pokemon_ongoing_battle(params[:pokemon_id]).count
    if pokemon_ongoing_battle_count > 0
      flash[:warning] = "Can't heal pokemon that still on a battle"
      redirect_to pokemon
      return
    end
    pokemon_skill = pokemon.pokemon_skills.find(params[:skill_id])
    pokemon_skill.destroy

    if pokemon_skill.destroyed?
      flash[:success] = "#{pokemon_skill.skill.name.titleize} has been removed!"
      redirect_to edit_pokemon_path(pokemon)
    else
      flash[:error] = "#{pokemon_skill.errors}"
      redirect_to edit_pokemon_path(pokemon), status: :unprocessable_entity
    end
  end



  private
  def pokemon_params
    params.require(:pokemon).permit(:name, :pokedex_id)
  end
end
