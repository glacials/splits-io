require 'rails_helper'

RSpec.describe 'runs/show' do
  it 'renders the show template' do
    assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
    render

    expect(view).to render_template('runs/show')
  end
end
