require 'rails_helper'

describe Api::V4::Games::RunnersController do
  describe '#index' do
    context 'for an exsiting game' do
      let(:game) { create(:game, :with_runners, :shortnamed) }
      subject { get :index, params: {game: game.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a runner schema' do
        expect(subject.body).to match_json_schema(:game_runners)
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
