require 'rails_helper'

describe Api::V4::RunsController do
  describe '#create' do
  end

  describe '#show' do
    context 'for a nonexistent run' do
      subject { get :show, params: {id: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for a bogus ID' do
      subject { get :show, params: {id: '/@??$@;[1;?'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an existing run' do
      let(:run) { create(:run) }
      subject { get :show, params: {id: run.id36} }
      let(:body) { JSON.parse(subject.body) }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'returns a body with no root node' do
        expect(body['id']).to eq run.id36
      end

      it 'includes a game' do
        expect(body['game']['id']).to eq run.game.id
      end

      it 'includes a category' do
        expect(body['category']['id']).to eq run.category.id
      end

      it 'includes a runner' do
        expect(body['runner']['id']).to eq run.runner.id
      end

      it 'has a number-like time' do
        expect(body['time']).to be_a_kind_of Float
      end

      it "doesn't include splits" do
        expect(body['splits']).to be_nil
      end

      it "doesn't include history" do
        expect(body['history']).to be_nil
      end

      it "doesn't include claim_token" do
        expect(body['claim_token']).to be_nil
      end

      it "doesn't include run_file_digest" do
        expect(body['run_file_digest']).to be_nil
      end

      context 'with historic=1' do
        subject { get :show, params: {id: run.id36, historic: '1'} }

        it 'includes history' do
          expect(body['history'][1]).to eq 6
        end
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    let(:run) { create(:run, user: user) }
    let(:body) { JSON.parse(subject.body) }

    context 'for a nonexistent run' do
      subject { put :update, params: {id: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an unauthenticated request' do
      subject { put :update, params: {id: run.id36, user: nil} }

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
      subject { put :update, params: params.merge(id: run.id36, claim_token: run.claim_token) }

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
      subject { delete :destroy, params: {id: run.id36} }

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
      subject { delete :destroy, params: {id: run.id36, claim_token: run.claim_token} }

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
