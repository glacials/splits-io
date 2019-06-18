require 'rails_helper'

describe Api::V4::Runs::SourceFilesController do
  describe '#show' do
    let(:run) { create(:run, :parsed) }
    subject { get :show, params: {run: run.id36} }

    it 'returns a 303' do
      expect(subject).to have_http_status :see_other
    end
  end

  describe '#update' do
    context 'with no OAuth token' do
      let(:run) { create(:run, :parsed) }
      subject { put :update, params: {run: run.id36} }

      it 'returns a 401' do
        expect(subject).to have_http_status(:unauthorized)
      end
    end

    context 'with an invalid OAuth token' do
      let(:run) { FactoryBot.create(:run, :parsed) }
      subject do
        request.headers.merge!('Authorization' => "Bearer beepboop")
        put :update, params: {run: run.id36}
      end

      it 'returns a 401' do
        expect(subject).to have_http_status(:unauthorized)
      end
    end

    context 'with a valid OAuth token' do
      let(:authorization) do
        Doorkeeper::AccessToken.create(
          application: Doorkeeper::Application.create(
            name: 'Test Application Please Ignore',
            redirect_uri: 'debug',
            owner: FactoryBot.create(:user)
          ),
          resource_owner_id: FactoryBot.create(:user).id,
          scopes: 'upload_run',
        )
      end

      let(:run) { FactoryBot.create(:run, :parsed) }
      subject do
        request.headers.merge!('Authorization' => "Bearer #{authorization.token}")
        put :update, params: {run: run.id36}
      end

      it 'returns a 202' do
        expect(subject).to have_http_status(:accepted)
      end
    end
  end
end
