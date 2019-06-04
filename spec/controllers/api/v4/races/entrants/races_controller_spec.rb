require 'rails_helper'

RSpec.describe Api::V4::Races::Entrants::RacesController do
  describe '#create' do
    let(:race) { FactoryBot.create(:race) }

    context 'with no authorization header' do
      subject(:response) { post :create, params: {race: race.to_param} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { post :create, params: {race: race.to_param} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      it 'returns a 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders an entrant schema' do
        # expect(response.body).to match_json_schema(:entrant)
      end
    end
  end

  describe '#update' do
    let(:race) { FactoryBot.create(:race) }
    let(:user) { FactoryBot.create(:user) }
    let(:entrant) { FactoryBot.create(:entrant, raceable: race, user: user) }

    context 'with no authorization header' do
      subject(:response) { patch :update, params: {race: race.to_param, readied_at: Time.now.utc} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { patch :update, params: {race: race.to_param} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      context 'with no entrant' do
        subject(:response) { patch :update, params: {race: race.to_param} }
        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entrant present' do
        before { entrant }

        context 'with no parameters' do
          subject(:response) { patch :update, params: {race: race.to_param} }

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'with 1 parameter to update' do
          let(:time) { Time.now.utc }
          subject(:response) { patch :update, params: {race: race.to_param, readied_at: 1, server_time: time.to_f * 1000} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders an entrant schema' do
            expect(response.body).to match_json_schema(:entrant)
          end

          it 'matches the given time' do
            expect(JSON.parse(response.body)['entrant']['readied_at']).to eq(time.iso8601(3))
          end
        end

        context 'with more than 1 parameter to update' do
          subject(:response) { patch :update, params: {race: race.to_param, readied_at: Time.now.utc, finished_at: Time.now.utc} }

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end
      end
    end
  end

  describe '#destroy' do
    let(:race) { FactoryBot.create(:race) }
    let(:user) { FactoryBot.create(:user) }
    let(:entrant) { FactoryBot.create(:entrant, raceable: race, user: user) }

    context 'with no authorization header' do
      subject(:response) { delete :destroy, params: {race: race.to_param} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { delete :destroy, params: {race: race.to_param} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      context 'with no entrant' do
        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entrant present' do
        before { entrant }
        it 'returns a 205' do
          expect(response).to have_http_status(:reset_content)
        end
      end
    end
  end
end
