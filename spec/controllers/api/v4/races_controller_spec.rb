require 'rails_helper'

RSpec.describe Api::V4::RacesController do
  describe '#index' do
    subject(:response) { get :index }

    context 'with no active races' do
      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index schema' do
        expect(response.body).to match_json_schema(:races)
      end
    end

    context 'with active races' do
      let(:races) { FactoryBot.create_list(:race, 10) }

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index schema' do
        expect(response.body).to match_json_schema(:races)
      end
    end
  end

  describe '#create' do
    context 'with no authorization header' do
      subject(:response) { post :create, params: {race: {category_id: 1}} }

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

      context 'with a nonsense category id' do
        subject(:response) { post :create, params: {race: {category_id: 'bleepy blooperson'}} }

        it 'returns a 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with a nonsense category id' do
        subject(:response) { post :create, params: {race: {category_id: '1234567890'}} }

        it 'returns a 400' do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with a valid category id' do
        subject(:response) { post :create, params: {race: {category_id: category.id}} }

        it 'returns a 201' do
          expect(response).to have_http_status(:created)
        end

        it 'renders a race schema' do
          expect(response.body).to match_json_schema(:race)
        end
      end

      context 'with a nil category id' do
        subject(:response) { post :create, params: {race: {category_id: nil}} }

        it 'returns a 201' do
          expect(response).to have_http_status(:created)
        end

        it 'renders a race schema' do
          expect(response.body).to match_json_schema(:race)
        end
      end
    end
  end

  describe '#show' do
    context 'with a bad id' do
      subject(:response) { get :show, params: {id: '!@#$'} }

      it 'returns a 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a valid id' do
      context 'with a public race' do
        let(:race) { FactoryBot.create(:race) }
        subject(:response) { get :show, params: {id: race.id} }

        it 'returns a 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders a race schema' do
          expect(response.body).to match_json_schema(:race)
        end
      end

      context 'with a secret race' do
        let(:race) { FactoryBot.create(:race, visibility: :secret) }

        context 'with no join token' do
          subject(:response) { get :show, params: {id: race.id} }

          it 'returns a 403' do
            expect(response).to have_http_status(:forbidden)
          end
        end

        context 'with a valid join token' do
          subject(:response) { get :show, params: {id: race.id, join_token: race.join_token} }

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders a race schema' do
            expect(response.body).to match_json_schema(:race)
          end
        end

        context 'with a entrants authorization header' do
          let(:user) { FactoryBot.create(:user) }
          let(:token) { FactoryBot.create(:access_token, resource_owner_id: user.id) }
          let(:entry) { FactoryBot.create(:entry, race: race, runner: user, creator: user) }
          subject(:response) { get :show, params: {id: race.id} }

          before do
            request.headers['Authorization'] = "Bearer #{token.token}"
            entry
          end

          it 'returns a 200' do
            expect(response).to have_http_status(:ok)
          end

          it 'renders a race schema' do
            expect(response.body).to match_json_schema(:race)
          end
        end
      end
    end
  end
end
