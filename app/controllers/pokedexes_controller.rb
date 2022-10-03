require "pry"
class PokedexesController < ApplicationController
  def index
    @pokedexes = Pokedex.page(params[:page])
  end

  def show
    @pokedex = Pokedex.find(params[:id])
  end

  def new
    @pokedex = Pokedex.new
  end

  def create
    @pokedex = Pokedex.new(pokedex_params)
    @pokedex.image_url = "0"

    if @pokedex.save
      flash[:success] = "Pokedex successfully created!"
      redirect_to @pokedex
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pokedex = Pokedex.find(params[:id])
  end

  def update
    @pokedex = Pokedex.find(params[:id])

    if @pokedex.update(pokedex_params)
      redirect_to @pokedex
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pokedex = Pokedex.find(params[:id])
    @pokedex.destroy

    redirect_to pokedexes_path
  end

  private

  def pokedex_params
    params.require(:pokedex).permit(:name, :health_point, :base_attack, :base_defense, :base_speed, :element_type, :image_url)
  end
end
