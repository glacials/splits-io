require 'rails_helper'

describe Api::V3::Users::Games::Categories::PredictionsController do
  let(:run) { FactoryBot.create(:run, :owned, :parsed) }

  describe '#show' do
    context 'when given a valid user, game, and category' do
      subject(:response) do
        get(:show, params: {user_id: run.user.id, game_id: run.game.id, category_id: run.category.id})
      end

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns no error' do
        expect(JSON.parse(response.body)['message']).to be_nil
      end

      it 'returns the correct segments' do
        expect(JSON.parse(response.body)['prediction']['splits']).to match_array(
          [
            {'best' => 1000, 'finish_time' => 1.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 2.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 3.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 4.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 5.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 6.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 7.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 8.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 9.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false},
            {'best' => 1000, 'finish_time' => 10.0, 'duration' => 1.0, 'gold?' => false, 'skipped?' => false}
          ]
        )
      end
    end
  end
end
