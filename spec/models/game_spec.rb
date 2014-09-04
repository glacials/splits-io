require 'spec_helper'

describe Game do
  it 'should be created properly' do
    game = Game.create!
    expect(game).to_not be nil
  end
end
