require 'rails_helper'

describe Api::V4::RunsController do
  let(:run) { FactoryGirl.create(:run) }

  describe '#show' do
    let(:returned_attributes) { [:id, :srdc_id, :name, :image_url, :user, :time, :video_url] }

    context 'when given a valid id36' do
      subject(:response) { get :show, params: {id: run.id36} }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected response code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct run' do
        returned_attributes.each do |attribute|
          expect(body[attribute.to_s]).to eq(
            attribute == :id ? run.id36 : run.send(attribute)
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

    context 'when setting an srdc_id with no authorization' do
      subject(:response) { put :update, params: {id: run.id36, srdc_id: 'bad id'} }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected status code' do
        expect(response).to have_http_status(401)
      end

      it 'does not update the run srdc_id' do
        expect(run.srdc_id).not_to eq('bad id')
      end
    end

    context 'when setting an srdc_id with invalid authorization' do
      subject(:response) { put :update, params: {claim_token: 'bad claim token', id: run.id36, srdc_id: 'bad id'} }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected status code' do
        expect(response).to have_http_status(401)
      end

      it 'does not update the run srdc_id' do
        expect(run.srdc_id).not_to eq('bad id')
      end
    end

    context 'when setting an srdc_id with valid authorization' do
      subject(:response) { put :update, params: {claim_token: run.claim_token, id: run.id36, srdc_id: 'good id'} }
      subject(:body) { JSON.parse(response.body) }

      it 'returns an expected status code' do
        expect(response).to have_http_status(204)
      end

      it 'updates the run srdc_id' do
        expect(run.srdc_id).not_to eq('good id')
      end
    end
  end
end
