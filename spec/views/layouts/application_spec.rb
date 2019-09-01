require 'rails_helper'

RSpec.describe 'layouts/application' do
  context 'while logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the index template' do
      render

      expect(view).to render_template('layouts/application')
    end

  end
  context 'while logged in' do
    before do
      user = FactoryBot.create(:user)
      allow(view).to receive(:current_user).and_return(user)
      controller.send(:create_auth_session, user)
    end

    it 'renders the index template' do
      render

      expect(view).to render_template('layouts/application')
    end
  end
end
