require 'rails_helper'

describe Api::V4::UsersController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#show' do
    it 'looks up the user by name' do
      get :show, id: user.name
      expect(response).to have_http_status(200)
    end

    context 'with a bad id' do
      it '404s' do
        get :show, id: 0
        expect(response).to have_http_status(404)
      end
    end
  end
end
