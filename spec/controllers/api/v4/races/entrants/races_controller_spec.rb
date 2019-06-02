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

  describe '#destroy' do
    let(:race) { FactoryBot.create(:race) }
    let(:user) { FactoryBot.create(:user) }
    let(:entrant) { FactoryBot.create(:entrant, raceable: race, user: user) }

    context 'with no authorization header' do
      subject(:response) { delete :destroy, params: {race: race.to_param, entrant: entrant.id} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { delete :destroy, params: {race: race.to_param, entrant: entrant.id} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      it 'returns a 205' do
        expect(response).to have_http_status(:reset_content)
      end
    end
  end
end
