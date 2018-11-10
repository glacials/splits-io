require 'rails_helper'

describe GoogleUsersController do
  describe '#in' do
    subject(:response) { get :in, params: {provider: 'google'} }

    context 'when given a proper user' do
      let(:env) do
        {
          'omniauth.auth' => double(
            uid: '29798286',
            info: double(
              email: 'qhiiyr@gmail.com',
              first_name: 'Ben',
              last_name: 'Carlsson',
              image: '',
              name: 'Glacials',
              nickname: 'glacials',
              urls: double(google: 'https://google.com/+bencarlsson')
            ),
            credentials: double(
              expires_at: Time.now + 1.day,
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
        it 'redirects to /' do
          expect(response).to redirect_to('/')
        end
      end
    end
  end

  describe '#unlink' do
    subject(:response) { get :unlink, params: {provider: 'google'} }
    before { allow(controller).to receive(:current_user).and_return(FactoryBot.build(:user)) }

    context 'when linked' do
      it 'redirects to /settings' do
        expect(response).to redirect_to(settings_path)
      end
    end

    context 'when not linked' do
      it 'redirects to /settings' do
        expect(response).to redirect_to(settings_path)
      end
    end
  end
end
