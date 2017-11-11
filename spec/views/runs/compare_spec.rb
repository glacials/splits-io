require 'rails_helper'

RSpec.describe 'runs/compare' do
  let(:user) { FactoryBot.create(:user) }

  before { allow(view).to receive(:current_user).and_return(user) }

  it 'renders the compare template' do
    assign(:run, FactoryBot.create(:run, :parsed, user: user))
    assign(:comparison_run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/compare')
  end
end
