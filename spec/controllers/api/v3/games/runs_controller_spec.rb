require 'rails_helper'

describe Api::V3::Games::RunsController do
  describe '#index' do
    context 'for an existing game' do
      let(:game) { FactoryBot.create(:game, :with_runs) }
      subject { get :index, params: {game_id: game.id} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end
    end

    context 'for a nonexisting game' do
      subject(:response) { get :index, params: {game_id: 0} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end
  end
end
