require 'rails_helper'

RSpec.describe 'runs/_split_table' do
  let(:run) do
    r = FactoryBot.create(:livesplit16_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'with realtime timing' do
    it 'renders the split table' do
      render(
        partial: 'runs/split_table',
        locals: {
          short: run.short?(Run::REAL),
          run: run,
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_split_table')
    end
  end

  context 'with gametime timing' do
    it 'renders the split table' do
      render(
        partial: 'runs/split_table',
        locals: {
          run: run,
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_split_table')
    end
  end
end
