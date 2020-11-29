require 'rails_helper'

RSpec.describe 'shared/_feed' do
  let(:user) { FactoryBot.create(:user) }

  it 'renders the feed template' do
    follow = FactoryBot.create(:user, :with_runs)
    allow(view).to receive(:current_user).and_return(user)
    allow(user.twitch).to receive(:follows).and_return([follow.twitch])

    render

    expect(view).to render_template('shared/_feed')
  end
end
