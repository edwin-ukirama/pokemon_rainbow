require "pry"
class PokedexesController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Pokédex", :pokedexes_path
  def index
    if params[:query].present?
      @pokedexes = Pokedex.where('pokedexes.name ILIKE ?', "%#{params[:query]}%")
      @pokedexes = @pokedexes.or(Pokedex.where('pokedexes.element_type ILIKE ?', "%#{params[:query]}%"))
      @pokedexes = @pokedexes.page(params[:page])
    else
      @pokedexes = Pokedex.page(params[:page])
    end
  end

  def show
    @pokedex = Pokedex.find(params[:id])
    add_breadcrumb "#{@pokedex.name}"
  end

  def new
    add_breadcrumb "Create"
    @pokedex = Pokedex.new
  end

  def create
    @pokedex = Pokedex.new(pokedex_params)


    if @pokedex.save
      flash[:success] = "Pokedex successfully created!"
      redirect_to @pokedex
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pokedex = Pokedex.find(params[:id])
    add_breadcrumb "Edit #{@pokedex.name}"
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
