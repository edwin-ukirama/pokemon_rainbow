require 'pry'
class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @skills = Skill.where(element_type: [@pokemon.pokedex.element_type, "normal"])
          .where.not(id: @pokemon.skills.ids)
  end

  def new
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
    @pokemon = Pokemon.find(params[:pokemon_id])
    @pokemon.current_health_point = @pokemon.max_health_point
    @pokemon.save

    flash[:success] = "#{@pokemon.name} has been healed!"

    redirect_to @pokemon
  end

  def add_skill
      @pokemon = Pokemon.find(params[:pokemon_id])
      @skill = Skill.find(params[:skill_id])
      @pokemon_skill = PokemonSkill.new
      @pokemon_skill.pokemon_id = @pokemon.id
      @pokemon_skill.skill_id = @skill.id
      @pokemon_skill.current_pp = @skill.max_pp

      if @pokemon_skill.save
        flash[:success] = "#{@skill.name} added!"
      else
        flash[:error] = "#{@pokemon_skill.errors}"
      end

      redirect_to @pokemon
  end

  def refill_skill_pp
    @pokemon = Pokemon.find(params[:pokemon_id])
    @pokemon_skill = @pokemon.pokemon_skills.find(params[:skill_id])
    @pokemon_skill.current_pp = @pokemon_skill.skill.max_pp

    if @pokemon_skill.save
      flash[:success] = "#{@pokemon_skill.skill.name.titleize} pp has been refilled!"
      redirect_to edit_pokemon_path(@pokemon)
    else
      flash[:error] = "#{@pokemon_skill.errors}"
      redirect_to edit_pokemon_path(@pokemon), status: :unprocessable_entity
    end
  end

  def remove_skill
    @pokemon = Pokemon.find(params[:pokemon_id])
    @pokemon_skill = @pokemon.pokemon_skills.find(params[:skill_id])
    @pokemon_skill.destroy

    if @pokemon_skill.destroyed?
      flash[:success] = "#{@pokemon_skill.skill.name.titleize} has been removed!"
      redirect_to edit_pokemon_path(@pokemon)
    else
      flash[:error] = "#{@pokemon_skill.errors}"
      redirect_to edit_pokemon_path(@pokemon), status: :unprocessable_entity
    end
  end



  private
  def pokemon_params
    params.require(:pokemon).permit(:name, :pokedex_id)
  end
end
