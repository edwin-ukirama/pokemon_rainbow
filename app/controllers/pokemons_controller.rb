require 'pry'
class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all
  end

  def show
    @pokemon = Pokemon.find(params[:id])
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
  end

  private
  def pokemon_params
    params.require(:pokemon).permit(:name, :pokedex_id)
  end
end
