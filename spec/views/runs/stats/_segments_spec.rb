require 'rails_helper'

RSpec.describe 'runs/stats/_segments' do
  it 'renders segment stats when there is no run history' do
    render(partial: 'runs/stats/segments', locals: {run: FactoryBot.create(:livesplit14_run)})

    expect(view).to render_template('runs/stats/_segments')
  end

  it 'renders segment stats when there is run history' do
    render(partial: 'runs/stats/segments', locals: {run: FactoryBot.create(:livesplit16_run)})

    expect(view).to render_template('runs/stats/_segments')
  end
end
