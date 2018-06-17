require 'rails_helper'

RSpec.describe 'rivalries/new' do
  let(:user) { FactoryBot.create(:user) }

  context 'with no category present' do
    it 'renders the new template' do
      allow(view).to receive(:current_user).and_return(user)
      render

      expect(view).to render_template('rivalries/new')
    end
  end

  context 'with a category present' do
    it 'renders the new template' do
      follow = FactoryBot.create(:user)

      category = FactoryBot.create(:category)
      assign(:category, category)

      FactoryBot.create(:run, category: category, user: user)
      FactoryBot.create(:run, category: category, user: follow)

      allow(view).to receive(:current_user).and_return(user)

      users = double
      allow(users).to receive(:twitch_followed_users).and_return(follow)

      render

      expect(view).to render_template('rivalries/new')
    end
  end
end
