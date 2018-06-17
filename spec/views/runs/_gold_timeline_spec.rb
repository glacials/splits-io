require 'rails_helper'

RSpec.describe 'runs/_gold_timeline' do
  let(:run) do
    r = FactoryBot.create(:livesplit16_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'with realtime timing' do
    it 'renders the gold timeline' do
      render(
        partial: 'runs/gold_timeline',
        locals: {
          run: run,
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_gold_timeline')
    end
  end

  context 'with gametime timing' do
    it 'renders the gold timeline' do
      render(
        partial: 'runs/gold_timeline',
        locals: {
          run: run,
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_gold_timeline')
    end
  end
end
