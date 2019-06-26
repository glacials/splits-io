# Shared code is tested in ./raceable_controllers_spec.rb

require 'rails_helper'

RSpec.describe Api::V4::Raceables::BingosController do
  describe '#create' do
    context 'with no authorization header' do
      subject(:response) { post :create, params: {game_id: 1} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      let(:game) { FactoryBot.create(:game) }
      subject(:response) { post :create, params: {game_id: game.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with an invalid game id' do
        subject(:response) { post :create, params: {game_id: nil} }

        it 'returns a 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with a valid game id' do
        subject(:response) { post :create, params: {game_id: game.id} }

        it 'returns a 201' do
          expect(response).to have_http_status(:created)
        end

        it 'renders a raceable schema' do
          expect(response.body).to match_json_schema(:bingo)
        end
      end
    end
  end

  describe '#update' do
    let(:bingo) { FactoryBot.create(:bingo) }

    context 'with no authorization header' do
      subject(:response) { patch :update, params: {raceable: bingo.id} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { patch :update, params: {raceable: bingo.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context "that doesn't belong to the bingo owner" do
        it 'returns a 401' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'that does belong to the bingo owner' do
        let(:bingo) { FactoryBot.create(:bingo, owner: user) }

        context 'with no card url parameter' do
          subject(:response) { patch :update, params: {raceable: bingo.id} }

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'with a card url parameter' do
          subject(:response) { patch :update, params: {raceable: bingo.id, card_url: 'https://google.com'} }

          context 'before the bingo has started' do
            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders a bingo schema' do
              expect(response.body).to match_json_schema(:bingo)
            end

            it 'saves the new url' do
              expect(JSON.parse(response.body)['bingo']['card_url']).to eq('https://google.com')
            end
          end

          context 'after the bingo has started' do
            before { bingo.update(started_at: Time.now.utc) }

            it 'returns a 409' do
              expect(response).to have_http_status(:conflict)
            end
          end
        end
      end
    end
  end
end
