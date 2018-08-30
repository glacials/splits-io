require 'rails_helper'

RSpec.describe 'rivalries/_user_candidates' do
  it 'renders user candidates' do
    user = FactoryBot.create(:user)
    follow = FactoryBot.create(:user)

    category = FactoryBot.create(:category)

    FactoryBot.create(:run, category: category, user: user)
    FactoryBot.create(:run, category: category, user: follow)

    allow(view).to receive(:current_user).and_return(user)

    users = double
    allow(users).to receive(:twitch_follows).and_return(users)
    allow(users).to receive(:that_run).and_return(users)
    allow(users).to receive(:find_each).and_yield(follow)

    allow(user).to receive(:twitch_follows).and_return(users)

    render(
      partial: 'rivalries/user_candidates', locals: {
        category: category
      }
    )

    expect(view).to render_template('rivalries/_user_candidates')
  end
end
