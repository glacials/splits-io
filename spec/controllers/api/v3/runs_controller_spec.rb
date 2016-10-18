require 'rails_helper'

describe Api::V3::RunsController do
  let(:run) { FactoryGirl.create_stubbed(:run) }

  describe '#show' do
    let(:returned_attributes) { [:id, :path, :image_url, :user, :time, :video_url] }

    context 'when given a valid id' do
      subject(:response) { get :show, params: {id: run.id} }
      subject(:body) { JSON.parse(response.body)['run'] }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct name' do
        expect(body['name']).to eq(run.to_s)
      end

      it 'returns the correct run' do
        returned_attributes.each do |attribute|
          expect(body[attribute.to_s]).to(
            eq(run.send(attribute)),
            "expected #{attribute} to be #{run.send(attribute)}, got #{body[attribute.to_s]}"
          )
        end
      end
    end

    context 'when given a bad id' do
      subject(:response) { get :show, params: {id: '...'} }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected response code' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error body' do
        expect(body['status']).to be_truthy
        expect(body['message']).to be_truthy
      end
    end
  end
end
