# This file tests all v4 API message raceable controllers as they all share the same code

require 'rails_helper'

raceables = {
  race:       Api::V4::Raceables::Messages::RacesController,
  bingo:      Api::V4::Raceables::Messages::BingosController,
  randomizer: Api::V4::Raceables::Messages::RandomizersController
}

raceables.each do |r, klass|
  RSpec.describe klass do
    describe '#index' do
      context 'with no raceable found' do
        subject(:response) { get :index, params: {raceable: '!@#$'} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with a public raceable' do
        let(:raceable) { FactoryBot.create(r) }
        subject(:response) { get :index, params: {raceable: raceable.id} }

        it 'returns a 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the index schema' do
          expect(response.body).to match_json_schema(:chat_messages)
        end
      end

      context 'with a secret raceable' do
        let(:raceable) { FactoryBot.create(r, visibility: :secret) }
        subject(:response) { get :index, params: {raceable: raceable.id} }

        context 'with no authorization header present' do
          it 'returns a 403' do
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'with a valid join token' do
          subject(:response) { get :index, params: {raceable: raceable.id, join_token: raceable.join_token} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders the index schema' do
            expect(response.body).to match_json_schema(:chat_messages)
          end
        end
      end
    end

    describe '#create' do
      let(:raceable) { FactoryBot.create(r) }
      subject(:response) { post :create, params: {raceable: raceable.id, body: 'test message here'} }

      context 'with no authorization header' do
        it 'returns a 401' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a valid authorization header' do
        let(:user) { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }

        before { request.headers['Authorization'] = "Bearer #{token.token}" }

        context 'with no raceable found' do
          subject(:response) { post :create, params: {raceable: '!@#$', body: 'test message here'} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with the user not in the raceable' do
          it 'returns a 201' do
            expect(response).to have_http_status(:created)
          end

          it 'renders a chat message schema' do
            expect(response.body).to match_json_schema(:chat_message)
          end

          it 'sets from_entry to false' do
            expect(JSON.parse(response.body)['chat_message']['from_entrant']).to be(false)
          end
        end

        context 'with the user present in the raceable' do
          let(:entry) { FactoryBot.create(:entry, user: user, raceable: raceable) }

          before { entry }

          it 'returns a 201' do
            expect(response).to have_http_status(:created)
          end

          it 'renders a chat message schema' do
            expect(response.body).to match_json_schema(:chat_message)
          end

          it 'sets from_entry to true' do
            expect(JSON.parse(response.body)['chat_message']['from_entrant']).to be(true)
          end
        end

        context 'with no body' do
          subject(:response) { post :create, params: {raceable: raceable.id} }

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end
      end
    end
  end
end
