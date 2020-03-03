require 'rails_helper'

RSpec.describe 'runs/exports/exchange' do
  it 'renders the Splits.io Exchange Format template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/exchange')
  end
end

RSpec.describe 'runs/exports/livesplit' do
  it 'renders the LiveSplit template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/livesplit')
  end
end

RSpec.describe 'runs/exports/splitterz' do
  it 'renders the SplitterZ template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/splitterz')
  end
end

RSpec.describe 'runs/exports/timesplittracker' do
  it 'renders the Time Split Tracker template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/timesplittracker')
  end
end

RSpec.describe 'runs/exports/urn' do
  it 'renders the Urn template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/urn')
  end
end

RSpec.describe 'runs/exports/wsplit' do
  it 'renders the WSplit template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/exports/wsplit')
  end
end
