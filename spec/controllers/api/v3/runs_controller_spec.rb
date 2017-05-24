require 'rails_helper'

describe Api::V3::RunsController do
  describe '#show' do
    let(:game) do
      instance_double(
        "Game",
        name: "Tron: Evolution",
        read_attribute_for_serialization: self,
      )
    end
    let(:category) do
      instance_double(
        "Category",
        game: game,
        name: "Any% NG+",
        read_attribute_for_serialization: self,
      )
    end
    let(:run) do
      instance_double(
        "Run",
        id: 10,
        id36: 'a',
        path: '/a',
        game: game,
        category: category,
        to_s: "Tron: Evolution Any% NG+",
        image_url: nil,
        sum_of_best: 2,
        splits: [
          instance_double("Split", 'best' => 3, 'best=' => true)
        ],
        read_attribute_for_serialization: self,
      )
    end

    context 'when given a valid id' do
      subject(:response) { get :show, params: {id: run.id36} }
      subject(:body) { JSON.parse(response.body)['run'] }

      it '200s' do
        expect(response).to have_http_status(200)
      end

      it 'returns a run with the correct id' do
        expect(body['id']).to eq(run.id)
      end
    end

    context 'when given a bad id' do
      subject(:response) { get :show, params: {id: '...'} }
      subject(:body) { JSON.parse(response.body) }

      it '404s' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error body' do
        expect(body['status']).to be_truthy
        expect(body['message']).to be_truthy
      end
    end
  end
end
