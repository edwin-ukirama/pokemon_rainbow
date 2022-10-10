Rails.application.routes.draw do
  root 'home#index'
  resources :pokemon_battles do
    post 'action-attack', to: 'pokemon_battles#action_attack', as: :action_attack
    get 'surrender', to: 'pokemon_battles#surrender', as: :action_surrender
  end
  resources :pokemon_skills
  resources :pokemons do
    get :heal, as: :heal
    get :heal_all, on: :collection, as: :heal_all
    post :add_skill, as: :add_skill
    post 'refill-skill/:skill_id', to: 'pokemons#refill_skill_pp', as: :refill_skill
    delete 'remove-skill/:skill_id', to: 'pokemons#remove_skill', as: :remove_skill
  end
  resources :skills
  resources :pokedexes
end
