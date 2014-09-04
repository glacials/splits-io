require 'spec_helper'

describe Category do
  it 'should be created properly' do
    category = Game.create!.categories.create!
    expect(category).to_not be nil
  end
end
