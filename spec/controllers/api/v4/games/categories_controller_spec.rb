require 'rails_helper'

describe Api::V4::Games::CategoriesController do
  let(:game) { FactoryGirl.create(:game) }
  let(:shortnamed_game) { FactoryGirl.create(:game, :shortnamed) }

  let(:category) { game.categories.create(name: 'Any%') }

  describe 'GET /api/v4/games/:game_id/categories' do
    it 'returns an array of categories' do
      get :index, game_id: game.id
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to eq('categories' => [])
    end
  end
end
