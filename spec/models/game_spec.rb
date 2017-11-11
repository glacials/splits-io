require 'rails_helper'

describe Game, type: :model do
  it 'creates absent games' do
    name = 'test game'
    expect(Game.from_name!(name).name).to eq name
  end

  it 'creates aliases for new games' do
    name = 'test game'
    expect(Game.create(name: name).aliases.first.name).to eq name
  end

  context 'that has categories' do
    let(:game) { FactoryBot.create(:game, :with_categories) }

    context 'when merged' do
      let(:parent_game) { FactoryBot.create(:game, :with_categories) }
      let(:game_category_names) { game.categories.pluck(:name) }
      let(:parent_game_category_names) { parent_game.categories.pluck(:name) }

      before do
        game.merge_into!(parent_game)
      end

      it 'destroys itself' do
        expect(game.destroyed?).to eq(true)
      end

      it 'has no categories left' do
        expect(game.categories.count).to eq(0)
      end

      it 'gives the other game its categories' do
        expect(parent_game.categories.pluck(:name)).to include(*game_category_names)
      end

      it "doesn't touch the other game's categories" do
        expect(parent_game.categories.pluck(:name)).to include(*parent_game_category_names)
      end

      it "doesn't migrate any unrelated categories" do
        expect(parent_game.categories.pluck(:name)).to eq((game_category_names + parent_game_category_names).uniq)
      end
    end
  end
end
