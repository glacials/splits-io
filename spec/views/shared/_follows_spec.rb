require 'rails_helper'

RSpec.describe 'shared/_follows' do
  let(:user) { FactoryBot.create(:user) }

  it 'renders the follows template' do
    follow = FactoryBot.create(:user, :with_runs)
    allow(view).to receive(:current_user).and_return(user)
    allow(user).to receive(:twitch_follows).and_return(follow)

    render

    expect(view).to render_template('shared/_follows')
  end
end
