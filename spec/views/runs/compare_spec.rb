require 'rails_helper'

RSpec.describe 'runs/compare' do
  let(:user) { FactoryGirl.create(:user) }

  before { allow(view).to receive(:current_user).and_return(user) }

  it 'renders the compare template' do
    assign(:run, FactoryGirl.create(:run, :parsed, user: user))
    assign(:comparison_run, FactoryGirl.create(:run, :parsed))
    render

    expect(view).to render_template('runs/compare')
  end
end
