require 'rails_helper'

describe Api::V4::Runners::GamesController do
  describe '#index' do
    context 'for an existing runner' do
      let(:runner) { create(:user, :with_runs) }
      subject { get :index, params: {runner: runner.name} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a game array schema' do
        expect(subject.body).to match_json_schema(:runner_games)
      end
    end

    context 'for a nonexisting runner' do
      subject { get :index, params: {runner: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end
  end
end
