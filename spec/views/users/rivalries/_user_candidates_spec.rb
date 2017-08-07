require 'rails_helper'

RSpec.describe 'users/rivalries/_user_candidates' do
  it 'renders user candidates' do
    user = FactoryGirl.create(:user)
    follow = FactoryGirl.create(:user)

    category = FactoryGirl.create(:category)

    FactoryGirl.create(:run, category: category, user: user)
    FactoryGirl.create(:run, category: category, user: follow)

    users = double
    allow(users).to receive(:follows).and_return(users)
    allow(users).to receive(:that_run).and_return(users)
    allow(users).to receive(:find_each).and_yield(follow)

    allow(user).to receive(:follows).and_return(users)

    render(partial: 'users/rivalries/user_candidates', locals: {
      user: user,
      category: category,
    })

    expect(view).to render_template('users/rivalries/_user_candidates')
  end
end
