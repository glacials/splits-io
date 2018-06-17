require 'rails_helper'

RSpec.describe 'applications/new' do
  let(:user) { FactoryBot.create(:user) }

  context 'when logged out' do
    before { allow(view).to receive(:current_user).and_return(nil) }

    it 'renders the new template' do
      render

      expect(view).to render_template('applications/new')
    end
  end

  context 'when logged in' do
    before { allow(view).to receive(:current_user).and_return(user) }

    it 'renders the new template' do
      render

      expect(view).to render_template('applications/new')
    end
  end
end
