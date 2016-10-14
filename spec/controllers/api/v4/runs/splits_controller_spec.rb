require 'rails_helper'

describe Api::V4::Runs::SplitsController do
  describe '#index' do
    context 'for a nonexistent run' do
      subject { get :index, params: {run: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for a bogus ID' do
      subject { get :index, params: {run: '/@??$@;[1;?'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end

      it 'returns no body' do
        expect(response.body).to be_blank
      end
    end

    context 'for an existing run' do
      let(:run) { create(:run) }
      subject { get :index, params: {run: run.id} }
      let(:body) { JSON.parse(subject.body) }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'returns a body with no root node' do
        expect(body[0]['name']).to eq 'Tron City'
      end

      it "doesn't include history" do
        expect(body[0]['history']).to be_nil
      end

      context 'with a historic=1 parameter' do
        subject { get :index, params: {run: run.id, historic: '1'} }

        it 'includes history' do
          expect(body[0]['history']).to eq [
            54.279395, 57.5447017, 57.234414, 53.2568428, 50.3245258, 55.0088332, 50.736531, 53.44994, 53.739547,
            53.4956392, 55.2457862, 49.7325244, 56.2357967, 54.4453876, 52.9656984, 53.9219256
          ]
        end
      end
    end
  end
end
