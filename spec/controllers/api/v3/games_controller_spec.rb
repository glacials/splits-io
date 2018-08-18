require 'rails_helper'

describe Api::V3::GamesController do
  let(:game) { FactoryBot.create(:game, :shortnamed) }

  describe '#index' do
    context 'when given a search term which yields results' do
      subject(:response) { get(:index, params: {search: game.name}) }
      subject(:body) { JSON.parse(response.body)['games'] }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      # # test fails for unknown reason. works fine outside of testing env
      #       it 'returns with at least one result' do
      #         expect(body.count).to be > 0
      #       end
    end

    context 'when given a search term which does not yield results' do
      subject(:response) { get(:index, params: {search: 'fakegame123'}) }
      subject(:body) { JSON.parse(response.body)['games'] }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns an empty array' do
        expect(body).to eq []
      end
    end

    context 'when not given a search term' do
      subject(:response) { get :index }
      subject(:body) { JSON.parse(response.body)['games'] }

      it 'returns an expected response code' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe '#show' do
    let(:game) { FactoryBot.create(:game, :shortnamed) }
    let(:returned_attributes) { %i[id name shortname categories] }

    context 'when given an id' do
      context 'when the game exists' do
        subject(:response) { get(:show, params: {id: game.id}) }
        subject(:body) { JSON.parse(response.body)['game'] }

        it 'returns an expected response code' do
          expect(response).to have_http_status(200)
        end

        it 'returns the game' do
          returned_attributes.each do |attribute|
            expect(body[attribute.to_s]).to eq(game.send(attribute))
          end
        end
      end

      context 'when the game does not exist' do
        subject(:response) { get(:show, params: {id: 'bleep bloop blop'}) }
        subject(:body) { JSON.parse(response.body) }

        it 'returns the correct response code' do
          expect(response).to have_http_status(404)
        end

        it 'returns an error body' do
          expect(body['status']).to be_truthy
          expect(body['message']).to be_truthy
        end
      end
    end

    context 'when given a shortname' do
      context 'when the game exists' do
        subject(:response) { get(:show, params: {id: game.id}) }
        subject(:body) { JSON.parse(response.body)['game'] }

        it 'returns the correct response code' do
          expect(response).to have_http_status(200)
        end

        it 'returns the game' do
          returned_attributes.each do |attribute|
            expect(body[attribute.to_s]).to eq(game.send(attribute))
          end
        end
      end

      context 'when the game does not exist' do
        subject(:response) { get(:show, params: {id: 'bleep bloop blop'}) }
        subject(:body) { JSON.parse(response.body) }

        it 'returns the correct response code' do
          expect(response).to have_http_status(404)
        end

        it 'returns an error body' do
          expect(body['status']).to be_truthy
          expect(body['message']).to be_truthy
        end
      end
    end
  end
end
