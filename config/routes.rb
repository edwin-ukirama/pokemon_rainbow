Rails.application.routes.draw do
  root 'home#index'
  resources :pokemons do
    get :heal, as: :heal
    get :heal_all, on: :collection, as: :heal_all
  end
  resources :skills
  resources :pokedexes
end
