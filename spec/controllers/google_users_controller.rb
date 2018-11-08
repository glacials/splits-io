require 'rails_helper'

describe GoogleUsersController do
  describe '#in' do
    subject(:response) { post :create, params: {provider: 'google'} }

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

      context 'and a redirect path via OmniAuth origin' do
        let(:redirect_path) { '/origin-redirect_path' }
        before { allow(request).to receive(:env) { env.merge('omniauth.origin' => redirect_path) } }

        it 'redirects correctly' do
          expect(response).to redirect_to(redirect_path)
        end
      end

      context 'and no redirect path' do
        it 'redirects to root' do
          expect(response).to redirect_to('/')
        end
      end
    end
  end
