require 'rails_helper'

RSpec.describe 'users/show' do
  let(:user) { FactoryBot.create(:user, :with_runs) }

  it 'renders the show template' do
    assign(:user, user)
    render

    expect(view).to render_template('users/show')
  end
end
