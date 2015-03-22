require 'rails_helper'

describe Api::V4::RunsController do
  let(:run) { FactoryGirl.create(:run) }

  describe '#show' do
    it 'looks up the run by id' do
      get :show, id: run.id36
      expect(response).to have_http_status(200)
    end

    it 'returns the correct run' do
      get :show, id: run.id36
      expect(JSON.parse(response.body)['run']['id']).to eq(run.id36)
    end

    context 'when given a bad id' do
      it 'returns a 404' do
        get :show, id: 0
        expect(response).to have_http_status(404)
      end
    end
  end
end
