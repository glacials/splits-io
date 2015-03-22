require 'rails_helper'

describe Api::V4::GamesController do
  let(:game) { FactoryGirl.create(:game) }

  describe '#index' do
    it 'returns a list of search results' do
      get :index, search: 'mario'
      expect(response).to have_http_status(200)
    end

    context 'when not given a search string' do
      it 'returns a 400' do
        get :index
        expect(response).to have_http_status(400)
      end
    end
  end

  describe '#show' do
    let(:game) { FactoryGirl.create(:game, :shortnamed) }

    it 'looks up the game by id' do
      get :show, id: game.id
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['game']['name']).to eq(game.name)
    end

    context 'when the game has categories' do
      it 'includes a list of categories' do
        get :show, id: game.id
        expect(JSON.parse(response.body)['game']['categories']).to eq([])
      end
    end

    context 'when the game has a shortname' do
      let(:game) { FactoryGirl.create(:game, :shortnamed) }

      it 'looks up the game by id' do
        get :show, id: game.id
        expect(response).to have_http_status(200)
      end

      it 'looks up the game by shortname' do
        get :show, id: game.shortname
        expect(response).to have_http_status(200)
      end
    end

    context 'when the game doesn\'t exist' do
      it '404s for numeric ids' do
        get :show, id: 99999
        expect(response).to have_http_status(404)
      end

      it '404s for string ids' do
        get :show, id: 'abc test id'
        expect(response).to have_http_status(404)
      end
    end
  end
end
