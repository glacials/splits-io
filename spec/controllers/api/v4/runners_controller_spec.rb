require 'rails_helper'

describe Api::V4::RunnersController do
  describe '#show' do
    context 'for an existing runner' do
      let(:runner) { create(:user, :with_runs) }
      subject { get :show, params: {runner: runner.name} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a runner schema' do
        expect(subject.body).to match_json_schema(:runner)
      end
    end
  end
end
