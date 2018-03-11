require 'rails_helper'

describe Api::V4::Games::RunsController do
  describe '#index' do
    context 'for an existing game' do
      let(:game) { create(:game, :with_runs, :shortnamed) }
      subject { get :index, params: {game: game.shortname} }

      it 'retruns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a run array schema' do
        expect(subject.body).to match_json_schema(:game_runs)
      end
    end

    context 'for a nonexisting game' do
      subject { get :index, params: {game: 'boopy'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end
  end
end
