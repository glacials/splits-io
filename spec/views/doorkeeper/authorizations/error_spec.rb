require 'rails_helper'

RSpec.describe 'doorkeeper/authorizations/error' do
  let(:user) { FactoryBot.create(:user) }

  context 'when logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the error template' do
      render

      expect(view).to render_template('doorkeeper/authorizations/error')
    end
  end

  context 'when logged in' do
    before { allow(view).to receive(:current_user).and_return(user) }

    it 'renders the error template' do
      assign(:pre_auth, double(error_response: double(body: {error_description: 'testing error'})))
      render

      expect(view).to render_template('doorkeeper/authorizations/error')
    end
  end
end
