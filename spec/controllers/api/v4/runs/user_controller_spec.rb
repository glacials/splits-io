require 'rails_helper'

describe Api::V4::Runs::UsersController do
  describe '#destroy' do
    context 'with no OAuth token' do
      context 'on an existing run' do
        let(:run) { create(:run) }
        subject { delete :destroy, params: {run: run.id36} }

        it 'returns a 401' do
          expect(subject).to have_http_status 401
        end
      end

      context 'on a nonexisting run' do
        subject { delete :destroy, params: {run: '0'} }

        it 'returns a 404' do
          expect(subject).to have_http_status 404
        end
      end
    end

    context 'with a non-matching OAuth token' do
      let(:run) { create(:run) }
      subject { delete :destroy, params: {run: run.id36} }

      it 'returns a 403' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(application_id: application.id, resource_owner_id: create(:user))
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(subject).to have_http_status 403
      end
    end

    context 'with a matching OAuth token' do
      let(:run) { create(:run, :owned) }
      subject { delete :destroy, params: {run: run.id36} }

      it 'returns a 205' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(
          application_id: application.id,
          resource_owner_id: run.user,
          scopes: 'delete_run'
        )
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(subject).to have_http_status 205
      end
    end
  end
end
