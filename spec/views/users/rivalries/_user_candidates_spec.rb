require 'rails_helper'

RSpec.describe 'users/rivalries/_user_candidates' do
  it 'renders user candidates' do
    allow_any_instance_of(User).to receive(:follows).and_return(User)
    render(partial: 'users/rivalries/user_candidates', locals: {user: FactoryGirl.create(:user), category: FactoryGirl.create(:category)})

    expect(view).to render_template('users/rivalries/_user_candidates')
  end
end
