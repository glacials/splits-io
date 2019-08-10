require 'rails_helper'

describe Api::V4::GamesController do
  describe '#index' do
    let(:games) { FactoryBot.create_list(:game, 5, :shortnamed) }

    context 'with a normal search' do
      subject { get :index, params: {search: 'The Legend of Mario: Melee Crossing'} }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with an id search' do
      let(:game) { FactoryBot.create(:game, name: 'Minesweeper') }
      subject { get :index, params: {search: game.id} }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#show' do
    context 'for an existing game' do
      let(:game) { create(:game, :shortnamed) }
      subject { get :show, params: {game: game.srdc.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status(:ok)
      end

      it 'renders a game schema' do
        expect(subject.body).to match_json_schema(:game)
      end
    end

    context 'for a nonexisting game' do
      subject { get :show, params: {game: 'boopy'} }

      it 'returns a 404' do
        expect(subject).to have_http_status(:not_found)
      end
    end
  end
end
