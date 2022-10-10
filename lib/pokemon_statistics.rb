class PokemonStatistics
  def self.get_most_win_pokemon
      result = []
      result = ActiveRecord::Base.connection.execute("SELECT pokemons.id, COUNT(pokemon_winner_id) as win_count FROM pokemons
      RIGHT JOIN pokemon_battles
      ON pokemons.id = pokemon_winner_id
      GROUP BY pokemons.id
      ORDER BY win_count DESC
      LIMIT 1;")
      result = result.values.flatten

      {
        :pokemon => Pokemon.find(result[0]),
        :win_count => result[1]
      }
  end

  def self.get_most_lost_pokemon
    result = []
    result = ActiveRecord::Base.connection.execute("SELECT pokemons.id, COUNT(pokemon_loser_id) as lose_count FROM pokemons
    RIGHT JOIN pokemon_battles
    ON pokemons.id = pokemon_loser_id
    GROUP BY pokemons.id
    ORDER BY lose_count DESC
    LIMIT 1;")
    result = result.values.flatten

    {
      :pokemon => Pokemon.find(result[0]),
      :lose_count => result[1]
    }
  end

  def self.get_most_surrender_pokemon
    result = []
    result = ActiveRecord::Base.connection.execute("SELECT attacker_id, count (action_type) FROM pokemon_battle_logs
    WHERE action_type = 'surrender'
    GROUP BY attacker_id
    LIMIT 1;")
    result = result.values.flatten

    {
      :pokemon => Pokemon.find(result[0]),
      :surrender_count => result[1]
    }
  end

  def self.get_most_picked_pokemon
    hash = PokemonBattle.pluck(:pokemon_1_id, :pokemon_2_id)
          .flatten
          .tally
    max = hash.max_by { |k,v| v}
    {
      :pokemon => Pokemon.find(max[0]),
      :count => max[1]
    }
  end
end
