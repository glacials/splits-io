# This file tests index and show methods from v4 API raceable controllers as they share the same code
# create and update are tested in their respective spec files

require 'rails_helper'

raceables = {
  race:       Api::V4::Raceables::RacesController,
  bingo:      Api::V4::Raceables::BingosController,
  randomizer: Api::V4::Raceables::RandomizersController
}

raceables.each do |r, klass|
  plural_r = r.to_s.pluralize.to_sym

  RSpec.describe klass do
    describe '#index' do
      subject(:response) { get :index }

      context 'with no active raceables' do
        it 'returns a 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the index schema' do
          expect(response.body).to match_json_schema(plural_r)
        end
      end

      context 'with active raceables' do
        let(:raceables) { FactoryBot.create_list(r, 10) }

        it 'returns a 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the index schema' do
          expect(response.body).to match_json_schema(plural_r)
        end
      end
    end

    describe '#show' do
      context 'with a bad id' do
        subject(:response) { get :show, params: {raceable: '!@#$'} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with a valid id' do
        context 'with a public raceable' do
          let(:raceable) { FactoryBot.create(r) }
          subject(:response) { get :show, params: {raceable: raceable.id} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders a raceable schema' do
            expect(response.body).to match_json_schema(r)
          end
        end

        context 'with a secret raceable' do
          let(:raceable) { FactoryBot.create(r, visibility: :secret) }

          context 'with no join token' do
            subject(:response) { get :show, params: {raceable: raceable.id} }

            it 'returns a 403' do
              expect(response).to have_http_status(:forbidden)
            end
          end

          context 'with a valid join token' do
            subject(:response) { get :show, params: {raceable: raceable.id, join_token: raceable.join_token} }

            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders a raceable schema' do
              expect(response.body).to match_json_schema(r)
            end
          end

          context 'with a entrants authorization header' do
            let(:user) { FactoryBot.create(:user) }
            let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
            let(:entry) { FactoryBot.create(:entry, raceable: raceable, user: user) }
            subject(:response) { get :show, params: {raceable: raceable.id} }

            before do
              request.headers['Authorization'] = "Bearer #{token.token}"
              entry
            end

            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders a raceable schema' do
              expect(response.body).to match_json_schema(r)
            end
          end
        end
      end
    end
  end
end
