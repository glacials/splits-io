require 'rails_helper'

RSpec.describe 'rivalries/_category_candidates' do
  it 'renders category candidates' do
    user = FactoryBot.create(:user)
    follow = FactoryBot.create(:user)

    category = FactoryBot.create(:category)

    FactoryBot.create(:run, category: category, user: user)
    FactoryBot.create(:run, category: category, user: follow)

    allow(view).to receive(:current_user).and_return(user)

    users = double
    allow(users).to receive(:twitch_follows).and_return(follow)

    render

    expect(view).to render_template('rivalries/_category_candidates')
  end
end
