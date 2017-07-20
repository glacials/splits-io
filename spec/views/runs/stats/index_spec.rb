require 'rails_helper'

RSpec.describe 'runs/stats/index' do
  it 'renders the index template' do
    assign(:run, FactoryGirl.create(:livesplit16_run, :parsed))
    render

    expect(view).to render_template('runs/stats/index')
  end
end
