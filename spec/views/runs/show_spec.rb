require 'rails_helper'

RSpec.describe 'runs/show' do
  it 'renders the show template' do
    assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
    assign(:compare_runs, [])
    render

    expect(view).to render_template('runs/show')
  end
  context 'when a compare run is set' do
    it 'renders the show template' do
      assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
      assign(:compare_runs, [FactoryBot.create(:livesplit16_run, :parsed)])
      render

      expect(view).to render_template('runs/show')
    end
  end
end
