require 'rails_helper'

raceables = {
  race:       Api::V4::Races::Entries::RacesController,
  bingo:      Api::V4::Races::Entries::BingosController,
  randomizer: Api::V4::Races::Entries::RandomizersController
}

raceables.each do |r, klass|
  RSpec.describe klass do
    describe '#show' do
      let(:raceable) { FactoryBot.create(r) }

      context 'with no authorization header' do
        subject(:response) { get :show, params: {raceable: raceable.id} }

        it 'returns a 403' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a valid authorization header' do
        let(:user) { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
        subject(:response) { get :show, params: {raceable: raceable.id} }

        before { request.headers['Authorization'] = "Bearer #{token.token}" }

        context 'with no raceable found' do
          subject(:response) { get :show, params: {raceable: '!@#$%'} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with no entry present' do
          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with an entry present' do
          let(:entry) { FactoryBot.create(:entry, raceable: raceable, user: user) }

          before { entry }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders an entry schema' do
            expect(response.body).to match_json_schema(:entry)
          end
        end
      end
    end

    describe '#create' do
      let(:raceable) { FactoryBot.create(r) }

      context 'with no authorization header' do
        subject(:response) { put :create, params: {raceable: raceable.id} }

        it 'returns a 403' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a valid authorization header' do
        let(:user) { FactoryBot.create(:user) }
        let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
        subject(:response) { put :create, params: {raceable: raceable.id} }

        before { request.headers['Authorization'] = "Bearer #{token.token}" }

        context 'with no raceable found' do
          subject(:response) { put :create, params: {raceable: '!@#$%'} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with the user in another race' do
          let(:secondary_raceable) { FactoryBot.create(r) }
          let(:entry) { FactoryBot.create(:entry, user: user, raceable: secondary_raceable) }

          it 'returns a 400' do
            entry # Touch entry so that it exists
            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'with the user available to join a race' do
          context 'with a secret race' do
            let(:raceable) { FactoryBot.create(r, visibility: :secret) }

            context 'with no join token' do
              it 'returns a 403' do
                expect(response).to have_http_status(:forbidden)
              end
            end

            context 'with an invalid join token' do
              subject(:response) { put :create, params: {raceable: raceable.id, join_token: '!@#$%'} }

              it 'returns a 403' do
                expect(response).to have_http_status(:forbidden)
              end
            end

            context 'with a valid join token' do
              subject(:response) { put :create, params: {raceable: raceable.id, join_token: raceable.join_token} }

              it 'returns a 201' do
                expect(response).to have_http_status(:created)
              end

              it 'renders an entry schema' do
                expect(response.body).to match_json_schema(:entry)
              end
            end
          end

          context 'with a public raceable' do
            it 'returns a 201' do
              expect(response).to have_http_status(:created)
            end

            it 'renders an entry schema' do
              expect(response.body).to match_json_schema(:entry)
            end
          end
        end
      end
    end

    describe '#update' do
      let(:raceable) { FactoryBot.create(r) }
      let(:user) { FactoryBot.create(:user) }
      let(:entry) { FactoryBot.create(:entry, raceable: raceable, user: user) }

      context 'with no authorization header' do
        subject(:response) { patch :update, params: {raceable: raceable.id, readied_at: Time.now.utc} }

        it 'returns a 403' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a valid authorization header' do
        let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
        subject(:response) { patch :update, params: {raceable: raceable.id} }

        before { request.headers['Authorization'] = "Bearer #{token.token}" }

        context 'with no raceable found' do
          subject(:response) { patch :update, params: {raceable: '!@#$'} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with no entry found' do
          subject(:response) { patch :update, params: {raceable: raceable.id} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with an entry present' do
          before { entry }

          context 'with no parameters' do
            subject(:response) { patch :update, params: {raceable: raceable.id} }

            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end
          end

          context 'with 1 parameter to update' do
            let(:time) { Time.now.utc }
            subject(:response) do
              patch :update, params: {raceable: raceable.id, entry: {readied_at: time.iso8601(3)}, format: :json}
            end

            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders an entry schema' do
              expect(response.body).to match_json_schema(:entry)
            end

            it 'matches the given time' do
              expect(JSON.parse(response.body)['entry']['readied_at']).to eq(time.iso8601(3))
            end
          end

          context 'who unreadies' do
            context 'before the raceable starts' do
              subject(:response) do
                patch :update, params: {
                  raceable: raceable.id,
                  entry:    {readied_at: nil}, format: :json
                }
              end

              before { entry.update(readied_at: Time.now.utc) }

              it 'returns a 200' do
                expect(response).to have_http_status(:ok)
              end

              it 'renders an entry schema' do
                expect(response.body).to match_json_schema(:entry)
              end

              it 'has a null readied_at' do
                expect(JSON.parse(response.body)['entry']['readied_at']).to eq(nil)
              end
            end

            context 'after the raceable starts' do
              before do
                entry.update(readied_at: Time.now.utc - 10.minutes)
                raceable.update(started_at: Time.now.utc)
              end

              subject(:response) do
                patch :update, params: {
                  raceable: raceable.id,
                  entry:    {readied_at: nil}, format: :json
                }
              end

              it 'returns a 400' do
                expect(response).to have_http_status(:bad_request)
              end
            end
          end

          context 'setting both forfeited and finished' do
            let(:time) { Time.now.utc }
            subject(:response) do
              patch :update, params: {
                raceable: raceable.id,
                entry:    {forfeited_at: time.iso8601(3), finished_at: time.iso8601(3)},
                format:   :json
              }
            end

            it 'returns a 400' do
              expect(response).to have_http_status(:bad_request)
            end
          end

          context 'setting run_id' do
            let(:run) { FactoryBot.create(:run, user: entry.user) }
            subject(:response) do
              patch :update, params: {
                raceable: raceable.id,
                entry:    {run_id: run.id36},
                format:   :json
              }
            end

            it 'returns a 200' do
              expect(response).to have_http_status(:ok)
            end

            it 'renders an entry schema' do
              expect(response.body).to match_json_schema(:entry)
            end

            it 'sets the correct run' do
              expect(JSON.parse(response.body)['entry']['run']['id']).to eq(run.id36)
            end
          end
        end
      end
    end

    describe '#destroy' do
      let(:raceable) { FactoryBot.create(r) }
      let(:user) { FactoryBot.create(:user) }
      let(:entry) { FactoryBot.create(:entry, raceable: raceable, user: user) }

      context 'with no authorization header' do
        subject(:response) { delete :destroy, params: {raceable: raceable.id} }

        it 'returns a 401' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with a valid authorization header' do
        let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
        subject(:response) { delete :destroy, params: {raceable: raceable.id} }

        before { request.headers['Authorization'] = "Bearer #{token.token}" }

        context 'with no raceable found' do
          subject(:response) { delete :destroy, params: {raceable: '!@#$'} }

          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with no entry' do
          it 'returns a 404' do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with an entry present' do
          before { entry }

          context 'before the raceable starts' do
            it 'returns a 205' do
              expect(response).to have_http_status(:reset_content)
            end
          end

          context 'after the raceable starts' do
            before { raceable.update(started_at: Time.now.utc) }

            it 'returns a 409' do
              expect(response).to have_http_status(409)
            end
          end
        end
      end
    end
  end
end
