require 'rails_helper'

RSpec.describe Api::V4::Races::Entries::RacesController do
  describe '#create' do
    let(:race) { FactoryBot.create(:race) }

    context 'with no authorization header' do
      subject(:response) { put :create, params: {raceable: race.id} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user) { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { put :create, params: {raceable: race.id} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      it 'returns a 201' do
        expect(response).to have_http_status(:created)
      end

      it 'renders an entry schema' do
        expect(response.body).to match_json_schema(:entry)
      end
    end
  end

  describe '#update' do
    let(:race) { FactoryBot.create(:race) }
    let(:user) { FactoryBot.create(:user) }
    let(:entry) { FactoryBot.create(:entry, raceable: race, user: user) }

    context 'with no authorization header' do
      subject(:response) { patch :update, params: {raceable: race.id, readied_at: Time.now.utc} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { patch :update, params: {raceable: race.id} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      context 'with no entry' do
        subject(:response) { patch :update, params: {raceable: race.id} }
        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entry present' do
        before { entry }

        context 'with no parameters' do
          subject(:response) { patch :update, params: {raceable: race.id} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with 1 parameter to update' do
          let(:time) { Time.now.utc }
          subject(:response) do
            patch :update, params: {raceable: race.id, entry: {readied_at: time.iso8601(3)}, format: :json}
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
          subject(:response) { patch :update, params: {raceable: race.id, entry: {readied_at: nil}, format: :json} }
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

        context 'setting both forfeited and finished' do
          let(:time) { Time.now.utc }
          subject(:response) do
            patch :update, params: {
              raceable: race.id,
              entry: {forfeited_at: time.iso8601(3), finished_at: time.iso8601(3)},
              format: :json,
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
              raceable: race.id,
              entry: {run_id: run.id36},
              format: :json
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
    let(:race) { FactoryBot.create(:race) }
    let(:user) { FactoryBot.create(:user) }
    let(:entry) { FactoryBot.create(:entry, raceable: race, user: user) }

    context 'with no authorization header' do
      subject(:response) { delete :destroy, params: {raceable: race.id} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { delete :destroy, params: {raceable: race.id} }

      before do
        request.headers['Authorization'] = "Bearer #{token.token}"
      end

      context 'with no entry' do
        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entry present' do
        before { entry }
        it 'returns a 205' do
          expect(response).to have_http_status(:reset_content)
        end
      end
    end
  end
end
