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
  context 'when a compare run has segment groups' do
    it 'renders the show template' do
      run = FactoryBot.create(:subsplits_with_titles_run)
      run.parse_into_db
      run.reload

      compare_run = FactoryBot.create(:subsplits_without_titles_run)
      compare_run.parse_into_db
      compare_run.reload

      assign(:run, run)
      assign(:compare_runs, [compare_run])
      render

      expect(view).to render_template('runs/show')
    end
  end
end
