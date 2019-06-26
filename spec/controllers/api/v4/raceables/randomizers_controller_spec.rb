# Shared code is tested in ./raceable_controllers_spec.rb

require 'rails_helper'

RSpec.describe Api::V4::Raceables::RandomizersController do
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
          expect(response.body).to match_json_schema(:randomizer)
        end
      end
    end
  end

  describe '#update' do
    let(:randomizer) { FactoryBot.create(:randomizer) }

    context 'with no authorization header' do
      subject(:response) { patch :update, params: {raceable: randomizer.id} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { patch :update, params: {raceable: randomizer.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context "that doesn't belong to the randomizer owner" do
        it 'returns a 401' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'that does belong to the randomizer owner' do
        let(:randomizer) { FactoryBot.create(:randomizer, owner: user) }

        context 'with no attachment parameter' do
          subject(:response) { patch :update, params: {raceable: randomizer.id} }

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'with an attachment parameter' do
          let(:file) { fixture_file_upload('files/seed_file') }
          subject(:response) { patch :update, params: {raceable: randomizer.id, randomizer: {attachments: file}} }

          context 'before the randomizer has started' do
            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders a randomizer schema' do
              expect(response.body).to match_json_schema(:randomizer)
            end
          end

          context 'after the randomizer has started' do
            before { randomizer.update(started_at: Time.now.utc) }

            it 'returns a 409' do
              expect(response).to have_http_status(:conflict)
            end
          end
        end
      end
    end
  end
end
