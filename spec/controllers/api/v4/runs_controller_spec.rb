require 'rails_helper'

describe Api::V4::RunsController do
  let(:correct_claim_token) { 'ralph waldo pickle chips!!' }
  let(:incorrect_claim_token) { "i don't know him." }

  describe '#create' do
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
