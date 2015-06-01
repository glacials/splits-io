require 'rails_helper'

describe Api::V4::GamesController do
  let(:game) { FactoryGirl.create(:game, name: 'Mario is Missing!') }

  describe '#index' do
    context 'when given a search term which yields results' do
      subject(:response) { get(:index, search: 'mario') }
      subject(:body) { JSON.parse(response.body)['runs'] }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the expected number of results' do
        expect(body.count).to eq 1
      end

      it 'contains the expected results' do
        expect(body[0]['name']).to eq 'Mario is Missing!'
      end
    end

    context 'when given a search term which does not yield results' do
      subject(:response) { get(:index, search: 'fakegame123') }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns an empty array' do
        expect(body).to eq []
      end
    end

    context 'when not given a search term' do
      subject(:response) { get :index }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected response code' do
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
