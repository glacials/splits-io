require 'rails_helper'

RSpec.describe Api::V4::Races::RacesController do
  describe '#create' do
    context 'with no authorization header' do
      subject(:response) { post :create, params: {category_id: 1} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      let(:category) { FactoryBot.create(:category) }
      subject(:response) { post :create, params: {category_id: category.id} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      it 'returns a 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders a race schema' do
        expect(response.body).to match_json_schema(:race)
      end
    end
  end

  describe '#show' do
    context 'with a bad id' do
      subject(:response) { get :show, params: {race: '-'} }

      it 'returns a 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a valid id' do
      let(:race) { FactoryBot.create(:race) }
      subject(:response) { get :show, params: {race: race.id} }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders a race schema' do
        expect(response.body).to match_json_schema(:race)
      end
    end
  end
end
