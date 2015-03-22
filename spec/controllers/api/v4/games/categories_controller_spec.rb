require 'rails_helper'

describe Api::V4::Games::CategoriesController do
  let(:category) { FactoryGirl.create(:category) }

  describe '#index' do
    it 'returns an array of categories' do
      get :index, game_id: category.game.id
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    it 'returns one category' do
      get :show, game_id: category.game.id, id: category.id
      expect(response).to have_http_status(200)
    end

    context 'given a mismatched game and category' do
      let(:mismatched_game) { FactoryGirl.create(:game) }

      it '404s' do
        get :show, game_id: mismatched_game.id, id: category.id
        expect(response).to have_http_status(404)
      end
    end

    context 'given a bad game id' do
      it '404s' do
        get :show, game_id: 0, id: category.id
        expect(response).to have_http_status(404)
      end
    end

    context 'given a bad category id' do
      it '404s' do
        get :show, game_id: category.game.id, id: 0
        expect(response).to have_http_status(404)
      end
    end
  end
end
