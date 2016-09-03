require 'rails_helper'

describe Api::V4::GamesController do
  describe '#index' do
  end

  describe '#show' do
    context 'for an existing game' do
      let(:game) { create(:game, :shortnamed) }
      subject { get :show, params: {game: game.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a game schema' do
        expect(subject.body).to match_json_schema(:game)
      end
    end

    context 'for a nonexisting game' do
      subject { get :show, params: {game: 'boopy'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end
  end

  describe '#categories' do
  end

  describe '#runners' do
  end

  describe '#runs' do
  end
end
