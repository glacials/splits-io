require 'rails_helper'

RSpec.describe 'doorkeeper/authorizations/new' do
  let(:user) { FactoryBot.create(:user) }

  context 'when logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the new template' do
      render

      expect(view).to render_template('doorkeeper/authorizations/new')
    end
  end

  context 'when logged in' do
    before { allow(view).to receive(:current_user).and_return(user) }

    it 'renders the new template' do
      assign(:pre_auth,
             double(
               client: double(name: 'test name', uid: 'test_id'),
               redirect_uri: 'http://localhost',
               state: 'test_state',
               scope: 'test_scope',
               response_type: 'test_response'
             ))
      render

      expect(view).to render_template('doorkeeper/authorizations/new')
    end
  end
end
