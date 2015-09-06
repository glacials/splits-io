require 'rails_helper'

describe Api::V4::Runs::SplitsController do
  describe '#index' do
    context "for a nonexistent run" do
      subject { get :index, params: {run_id: '0'} }

      it "returns a 404" do
        expect(subject).to have_http_status 404
      end

      it "returns no body" do
        expect(response.body).to be_blank
      end
    end

    context "for a bogus ID" do
      subject { get :index, params: {run_id: '/@??$@;[1;?'} }

      it "returns a 404" do
        expect(subject).to have_http_status 404
      end

      it "returns no body" do
        expect(response.body).to be_blank
      end
    end

    context "for an existing run" do
      let(:run) { create(:run) }
      subject { get :index, params: {run_id: run.id36} }
      let(:body) { JSON.parse(subject.body) }

      it "returns a 200" do
        expect(subject).to have_http_status 200
      end

      it "returns a body with no root node" do
        expect(body[0]['name']).to eq "Tron City"
      end

      it "doesn't include history" do
        expect(body[0]['history']).to be_nil
      end

      context "with a slow=true parameter" do
        subject { get :index, params: {run_id: run.id36, slow: true} }

        it "includes history" do
          expect(body[0]['history']).to eq '6'
        end
      end
    end
  end
end
