require 'rails_helper'

RSpec.configure do |c|
  c.include RunsHelper
end

RSpec.describe 'shared/_run_table' do
  it 'renders the run table' do
    render(partial: 'shared/run_table', locals: table_locals(:games, games: [FactoryBot.create(:game)]))

    expect(view).to render_template('shared/_run_table')
  end
end
