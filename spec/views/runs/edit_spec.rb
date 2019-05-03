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
end
