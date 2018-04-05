require 'rails_helper'

describe SessionsController do
  describe '#create' do
    subject(:response) { post :create, params: {provider: 'twitch'} }

    context 'when given a proper user' do
      let(:env) do
        {
          'omniauth.auth' => double(
            uid: '29798286',
            info: double(
              nickname: 'glacials',
              name: 'Glacials',
              email: 'qhiiyr@gmail.com',
              image: ''
            ),
            credentials: double(
              token: ''
            )
          )
        }
      end
      before { allow(request).to receive(:env) { env } }

      context 'when given an redirect path via OmniAuth origin' do
        let(:redirect_path) { '/origin-redirect_path' }
        before { allow(request).to receive(:env) { env.merge('omniauth.origin' => redirect_path) } }

        it 'redirects correctly' do
          expect(response).to redirect_to(redirect_path)
        end
      end

      context 'when given no redirect path' do
        it 'redirects to root' do
          expect(response).to redirect_to('/')
        end
      end
    end
  end
end
