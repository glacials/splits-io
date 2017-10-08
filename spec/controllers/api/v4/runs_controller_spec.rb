require 'rails_helper'

describe Api::V4::RunsController do
  let(:correct_claim_token) { 'ralph waldo pickle chips!!' }
  let(:incorrect_claim_token) { "i don't know him." }

  describe '#create' do
    let(:run) do
      create(:run)
    end

    context 'when given a cookie' do
      subject(:response) { post :create, params: {file: run.file} }
      let(:u) { build(:user) }
      before { allow(controller).to receive(:current_user) { u } }

      it 'returns a 201' do
        expect(response).to have_http_status 201
      end

      it 'creates a run that belongs to the logged in user' do
        id = JSON.parse(response.body)['id']
        run = Run.find36(id)
        expect(run.user).to eq u
      end
    end

    context 'when given no cookie and no OAuth token' do
      subject(:response) { post :create, params: {file: run.file} }

      it 'returns a 201' do
        expect(response).to have_http_status 201
      end
    end

    context 'when given an invalid OAuth token' do
      subject(:response) { post :create, params: {file: run.file} }

      it 'returns a 401' do
        request.headers['Authorization'] = 'Bearer bad_token'

        expect(response).to have_http_status 401
      end
    end

    context 'when given a valid OAuth token with no scopes' do
      subject(:response) { post :create, params: {file: run.file} }

      it 'returns a 403' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(application_id: application.id, resource_owner_id: create(:user))
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(response).to have_http_status 403
      end
    end

    context 'when given a valid OAuth token with an upload_run scope' do
      subject(:response) { post :create, params: {file: run.file} }

      it 'returns a 201' do
        application = Doorkeeper::Application.create(
          name: 'Test Application',
          redirect_uri: 'http://localhost:3000/',
          owner: create(:user)
        )
        authorization = Doorkeeper::AccessToken.create(
          application_id: application.id,
          resource_owner_id: create(:user),
          scopes: 'upload_run'
        )
        auth_header = "Bearer #{authorization.token}"
        request.headers['Authorization'] = auth_header

        expect(response).to have_http_status 201
      end
    end
  end

  describe '#show' do
    context 'for a nonexistent run' do
      subject { get :show, params: {run: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'for a bogus ID' do
      subject { get :show, params: {run: '/@??$@;[1;?'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'for an existing run' do
      let(:run) { create(:run, :owned) }
      subject { get :show, params: {run: run.id36} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a run schema' do
        expect(subject.body).to match_json_schema(:run)
      end
    end

    context 'for an existing run with historic=1' do
      let(:run) { create(:run, :owned) }
      subject { get :show, params: {run: run.id36, historic: '1'} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a run schema' do
        expect(subject.body).to match_json_schema(:run)
      end
    end

    context 'for an existing run with a valid accept header' do
      let(:run) { create(:run, :owned, :parsed) }
      subject(:response) { get :show, params: {run: run.id36} }

      it 'returns a 200' do
        request.headers["Accept"] = 'application/wsplit'

        expect(subject).to have_http_status 200
      end

      it 'returns the correct content-type header' do
        request.headers["Accept"] = 'application/wsplit'

        expect(response.content_type).to eq('application/wsplit')
      end
    end

    context 'for an existing run with a bogus accept header' do
      let(:run) { create(:run, :owned, :parsed) }
      subject(:response) { get :show, params: {run: run.id36} }

      it 'returns a 406' do
        request.headers["Accept"] = 'application/liversplit'

        expect(subject).to have_http_status 406
      end

      it 'returns the correct content-type header' do
        request.headers["Accept"] = 'application/liversplit'

        expect(response.content_type).to eq('application/json')
      end
    end

    context 'for an existing run with a valid original timer accept header' do
      let(:run) { create(:run, :owned, :parsed) }
      subject(:response) { get :show, params: {run: run.id36} }

      it 'returns a 200' do
        request.headers["Accept"] = 'application/original-timer'

        expect(subject).to have_http_status 200
      end

      it 'returns the correct content-type header' do
        request.headers["Accept"] = 'application/original-timer'

        expect(response.content_type).to eq('application/livesplit')
      end
    end
  end

  describe '#update' do
    let(:old_srdc_id) { 'throw a blanket over it!' }
    let(:new_srdc_id) { 'put a little fence around it!' }

    context 'with no claim token' do
      subject { put :update, params: {run: run.id36, srdc_id: new_srdc_id} }

      context 'when the run has a null claim token' do
        let(:run) { create(:run, claim_token: nil) }

        it 'returns a 401' do
          expect(subject).to have_http_status 401
        end
      end

      context 'when the run has a claim token' do
        let(:run) { create(:run, claim_token: correct_claim_token) }

        it 'returns a 401' do
          expect(subject).to have_http_status 401
        end
      end
    end

    context 'with a non-matching claim token' do
      let(:run) { create(:run, claim_token: correct_claim_token, srdc_id: old_srdc_id) }
      subject { put :update, params: {run: run.id36, srdc_id: old_srdc_id, claim_token: incorrect_claim_token} }

      it 'returns a 403' do
        expect(subject).to have_http_status 403
      end
    end

    context 'with a matching claim token' do
      let(:run) { create(:run, claim_token: correct_claim_token, srdc_id: old_srdc_id) }
      subject { put :update, params: {run: run.id36, srdc_id: new_srdc_id, claim_token: correct_claim_token} }

      it 'returns a 204' do
        expect(subject).to have_http_status 204
      end
    end
  end

  describe '#destroy' do
    context 'with no claim token' do

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

    context 'with a non-matching claim token' do
      let(:run) { create(:run, claim_token: correct_claim_token) }
      subject { delete :destroy, params: {run: run.id36, claim_token: incorrect_claim_token} }

       it 'returns a 403' do
         expect(subject).to have_http_status 403
       end
    end

    context 'with a matching claim token' do
      let(:run) { create(:run, claim_token: correct_claim_token) }
      subject { delete :destroy, params: {run: run.id36, claim_token: correct_claim_token} }

      it 'returns a 204' do
        expect(subject).to have_http_status 204
      end
    end
  end
end
