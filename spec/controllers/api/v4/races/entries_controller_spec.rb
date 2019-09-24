require 'rails_helper'

RSpec.describe Api::V4::Races::EntriesController do
  describe '#show' do
    let(:user)  { FactoryBot.create(:user) }
    let(:race)  { FactoryBot.create(:race) }
    let(:entry) { FactoryBot.create(:entry, race: race, runner: user, creator: user) }

    context 'with no authorization header' do
      subject(:response) { get :show, params: {race_id: race.id, id: entry.id} }

      it 'returns a 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user)  { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with no race found' do
        subject(:response) { get :show, params: {race_id: '!@#$%', id: entry.id} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entry present' do
        subject(:response) { get :show, params: {race_id: entry.race.id, id: entry.id} }

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
    let(:race) { FactoryBot.create(:race) }

    context 'with no authorization header' do
      subject(:response) { put :create, params: {race_id: race.id} }

      it 'returns a 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:user)  { FactoryBot.create(:user) }
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { put :create, params: {race_id: race.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with no race found' do
        subject(:response) { put :create, params: {race_id: '!@#$%'} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'as a ghost' do
        subject(:response) { put :create, params: {race_id: '!@#$%', entry: {run_id: FactoryBot.create(:run).id}} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with the user in another race' do
        let(:secondary_race) { FactoryBot.create(:race) }
        let(:entry)          { FactoryBot.create(:entry, runner: user, creator: user, race: secondary_race) }

        it 'returns a 400' do
          entry # Touch entry so that it exists
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with the user available to join a race' do
        context 'with a secret race' do
          let(:race) { FactoryBot.create(:race, visibility: :secret) }

          context 'with no join token' do
            it 'returns a 403' do
              expect(response).to have_http_status(:forbidden)
            end
          end

          context 'with an invalid join token' do
            subject(:response) { put :create, params: {race_id: race.id, join_token: '!@#$%'} }

            it 'returns a 403' do
              expect(response).to have_http_status(:forbidden)
            end
          end

          context 'with a valid join token' do
            subject(:response) { put :create, params: {race_id: race.id, join_token: race.join_token} }

            it 'returns a 201' do
              expect(response).to have_http_status(:created)
            end

            it 'renders an entry schema' do
              expect(response.body).to match_json_schema(:entry)
            end
          end
        end

        context 'with a public race' do
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
    let(:race)  { FactoryBot.create(:race) }
    let(:user)  { FactoryBot.create(:user) }
    let(:entry) { FactoryBot.create(:entry, race: race, runner: user, creator: user) }

    context 'with no authorization header' do
      subject(:response) { patch :update, params: {race_id: race.id, id: entry.id, entry: {readied_at: Time.now.utc}} }

      it 'returns a 403' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
      subject(:response) { patch :update, params: {race_id: race.id, id: entry.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with no race found' do
        subject(:response) { patch :update, params: {race_id: '!@#$', id: entry.id} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with no entry found' do
        subject(:response) { patch :update, params: {race_id: race.id, id: 'beepy beeperson'} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entry present' do
        before { entry }

        context 'with no parameters' do
          subject(:response) { patch :update, params: {race_id: race.id, id: entry.id} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'with 1 parameter to update' do
          let(:time) { Time.now.utc }

          subject(:response) do
            patch :update, params: {race_id: race.id, id: entry.id, entry: {readied_at: time.iso8601(3)}, format: :json}
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

        context 'with a readied_at of "now"' do
          let(:time) { Time.now.utc }
          before { allow(Time).to receive(:now).and_return(time) }

          subject(:response) do
            patch :update, params: {race_id: race.id, id: entry.id, entry: {readied_at: 'now'}, format: :json}
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
          context 'before the race starts' do
            subject(:response) do
              patch :update, params: {
                race_id: race.id,
                id:      entry.id,
                entry:   {readied_at: nil}, format: :json
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

          context 'after the race starts' do
            before do
              entry.update(readied_at: Time.now.utc - 10.minutes)
              race.update(started_at: Time.now.utc)
            end

            subject(:response) do
              patch :update, params: {
                race_id: race.id,
                id:      entry.id,
                entry:   {readied_at: nil}, format: :json
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
              race_id: race.id,
              id:      entry.id,
              entry:   {forfeited_at: time.iso8601(3), finished_at: time.iso8601(3)},
              format:  :json
            }
          end

          it 'returns a 400' do
            expect(response).to have_http_status(:bad_request)
          end
        end

        context 'setting run_id' do
          let(:run) { FactoryBot.create(:run, :parsed, user: user) }
          subject(:response) do
            patch :update, params: {
              race_id: race.id,
              id:      entry.id,
              entry:   {run_id: run.id36},
              format:  :json
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
    let(:race)  { FactoryBot.create(:race) }
    let(:user)  { FactoryBot.create(:user) }
    let(:entry) { FactoryBot.create(:entry, race: race, runner: user, creator: user) }

    context 'with no authorization header' do
      subject(:response) { delete :destroy, params: {race_id: race.id, id: entry.id} }

      it 'returns a 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid authorization header' do
      let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }

      subject(:response) { delete :destroy, params: {race_id: race.id, id: entry.id} }

      before { request.headers['Authorization'] = "Bearer #{token.token}" }

      context 'with no race found' do
        subject(:response) { delete :destroy, params: {race_id: 'beep', id: entry.id} }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with no entry' do
        before { entry.destroy }

        it 'returns a 404' do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with an entry present' do
        before { entry }

        context 'before the race starts' do
          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end
        end

        context 'after the race starts' do
          before { race.update(started_at: Time.now.utc) }

          it 'returns a 409' do
            expect(response).to have_http_status(409)
          end
        end
      end
    end
  end
end
