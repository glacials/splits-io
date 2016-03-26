require 'rails_helper'

describe Game, type: :model do
  it 'creates absent games' do
    name = 'test game'
    expect(Game.from_name(name).name).to eq name
  end

  it 'creates aliases for new games' do
    name = 'test game'
    expect(Game.create(name: name).aliases.first.name).to eq name
  end
end
