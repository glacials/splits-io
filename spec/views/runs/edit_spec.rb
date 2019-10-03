require 'rails_helper'

RSpec.describe 'runs/edit' do
  it 'renders the edit template' do
    assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
    assign(:compare_runs, [])
    render

    expect(view).to render_template('runs/edit')
  end

  context 'with a compare run' do
    it 'renders the edit template' do
      assign(:run, FactoryBot.create(:livesplit16_run, :parsed))
      assign(:compare_runs, [FactoryBot.create(:livesplit16_run, :parsed)])
      render

      expect(view).to render_template('runs/edit')
    end
  end

  context 'with a compare run that has segment groups' do
    it 'renders the edit template' do
      run = FactoryBot.create(:subsplits_with_titles_run)
      run.parse_into_db
      run.reload

      compare_run = FactoryBot.create(:subsplits_without_titles_run)
      compare_run.parse_into_db
      compare_run.reload

      assign(:run, run)
      assign(:compare_runs, [compare_run])
      render

      expect(view).to render_template('runs/edit')
    end
  end
end
