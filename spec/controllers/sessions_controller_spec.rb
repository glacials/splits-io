require 'rails_helper'

describe SessionsController do
  describe '#destroy' do
    subject(:response) { delete :destroy, params: {session: 'bloop'} }

    context 'when logged in' do
      before { allow(controller).to receive(:auth_session) { double(invalidate!: true) } }
      it 'returns a 200' do
        expect(response).to have_http_status(302)
      end
    end

    context 'when not logged in' do
      before { allow(controller).to receive(:auth_session) { double(invalidate!: false) } }
      it 'returns a 200' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
