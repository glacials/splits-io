# Shared code is tested in ./raceable_controllers_spec.rb

require 'rails_helper'

RSpec.describe Api::V4::Raceables::RacesController do
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

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with an invalid category id' do
        subject(:response) { post :create, params: {category_id: nil} }

        it 'returns a 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with a valid category id' do
        subject(:response) { post :create, params: {category_id: category.id} }

        it 'returns a 201' do
          expect(response).to have_http_status(:created)
        end

        it 'renders a raceable schema' do
          expect(response.body).to match_json_schema(:race)
        end
      end
    end
  end
end
