require "test_helper"

class PokedexTest < ActiveSupport::TestCase
  test 'invalid without name' do
    pokedex = Pokedex.new
    assert_not pokedex.save
  end
end
