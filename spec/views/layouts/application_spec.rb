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
    before { allow(view).to receive(:current_user).and_return(FactoryBot.build(:user)) }

    it 'renders the index template' do
      render

      expect(view).to render_template('layouts/application')
    end
  end
end
