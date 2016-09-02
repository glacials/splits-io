require 'rails_helper'

describe Api::V4::RunsController do
  describe '#create' do
  end

  describe '#show' do
    context 'for a nonexistent run' do
      subject { get :show, params: {run: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for a bogus ID' do
      subject { get :show, params: {run: '/@??$@;[1;?'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an existing run' do
      let(:run) { create(:run, :owned) }
      subject { get :show, params: {run: run.id36} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'returns the run' do
        expect(subject.body).to match_json_schema(:run)
      end

    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    let(:run) { create(:run, user: user) }
    let(:body) { JSON.parse(subject.body) }

    context 'for a nonexistent run' do
      subject { put :update, params: {run: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an unauthenticated request' do
      subject { put :update, params: {run: run.id36, user: nil} }

      it 'returns a 401' do
        expect(response).to have_http_status 401
      end

      it "doesn't update the run" do
        expect(run.user).to be user
      end

      it 'returns an error asking for a claim token' do
        expect(body['error']).to 'You must supply a claim_token to authorize as the owner of this run.'
      end
    end

    context 'for an authenticated request' do
      subject { put :update, params: params.merge(run: run.id36, claim_token: run.claim_token) }

      it 'returns a 204' do
        expect(response).to have_http_status 204
      end

      it 'updates image_url' do
        let(:params) { {image_url: 'http://google.com/'} }
        expect(run.image_url).to eq params[:image_url]
      end

      it 'updates srdc_id' do
        let(:params) { {srdc_id: '4'} }
        expect(run.srdc_id).to eq params[:srdc_id]
      end

      it 'disowns' do
        let(:params) { {user: nil} }
        expect(run.user).to be_nil
      end

      it 'does not allow switching owners' do
        let(:params) { {user: create(:user)} }
        expect(run.user).to be_nil
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user) }
    let(:run) { create(:run, user: user) }
    let(:body) { JSON.parse(subject.body) }

    context 'for a nonexistent run' do
      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an unauthenticated request' do
      subject { delete :destroy, params: {run: run.id36} }

      it 'returns a 401' do
        expect(response).to have_http_status 401
      end

      it "doesn't destroy the run" do
        expect(run.destroyed?).to be false
      end

      it 'returns no body' do
        expect(body['error']).to eq 'You must supply a claim_token to authorize as the owner of this run.'
      end
    end

    context 'for an authenticated request' do
      subject { delete :destroy, params: {run: run.id36, claim_token: run.claim_token} }

      it 'returns a 204' do
        expect(response).to have_http_status 204
      end

      it 'destroys the run' do
        expect(run.destroyed?).to be true
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end
  end
end
