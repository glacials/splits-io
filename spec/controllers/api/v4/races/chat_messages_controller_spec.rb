require 'rails_helper'

RSpec.describe Api::V4::Races::ChatMessagesController do
  describe '#index' do
    context 'with no race found' do
      subject(:response) { get :index, params: {race_id: '!@#$'} }

      it 'returns a 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a public race' do
      let(:race) { FactoryBot.create(:race) }
      subject(:response) { get :index, params: {race_id: race.id} }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index schema' do
        expect(response.body).to match_json_schema(:chat_messages)
      end
    end

    context 'with a secret race' do
      let(:race) { FactoryBot.create(:race, visibility: :secret) }
      subject(:response) { get :index, params: {race_id: race.id} }

      context 'with no authorization header present' do
        it 'returns a 403' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with a valid join token' do
        subject(:response) { get :index, params: {race_id: race.id, join_token: race.join_token} }

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
    let(:race) { FactoryBot.create(:race) }
    subject(:response) { post :create, params: {race_id: race.id, chat_message: {body: 'test message here'}} }

    context 'with no authorization header' do
      it 'returns a 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with no race found' do
        subject(:response) { post :create, params: {race_id: '!@#$', chat_message: {body: 'test message here'}} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with the user not in the race' do
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

      context 'with the user present in the race' do
        let(:entry) { FactoryBot.create(:entry, runner: user, creator: user, race: race) }

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
        subject(:response) { post :create, params: {race_id: race.id} }

        it 'returns a 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
