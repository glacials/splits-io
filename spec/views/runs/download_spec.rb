require 'rails_helper'

RSpec.describe 'runs/urn' do
  it 'renders the Urn template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/urn')
  end
end

RSpec.describe 'runs/livesplit' do
  it 'renders the LiveSplit template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/livesplit')
  end
end

RSpec.describe 'runs/splitterz' do
  it 'renders the SplitterZ template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/splitterz')
  end
end

RSpec.describe 'runs/timesplittracker' do
  it 'renders the Time Split Tracker template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/timesplittracker')
  end
end

RSpec.describe 'runs/wsplit' do
  it 'renders the WSplit template' do
    assign(:run, FactoryBot.create(:run, :parsed))
    render

    expect(view).to render_template('runs/wsplit')
  end
end
