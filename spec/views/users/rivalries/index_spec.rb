require 'rails_helper'

RSpec.describe 'users/rivalries/index' do
  it 'renders the index template' do
    assign(:rivalries, [FactoryGirl.create(:rivalry)])
    assign(:user, [FactoryGirl.create(:user)])
    render

    expect(view).to render_template('users/rivalries/index')
  end
end
