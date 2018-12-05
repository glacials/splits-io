require 'rails_helper'

RSpec.describe 'runs/_stats' do
  let(:run) do
    r = FactoryBot.create(:livesplit14_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'with realtime timing' do
    it 'renders stats' do
      render(
        partial: 'runs/stats',
        locals: {
          run: run,
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_stats')
    end
  end

  context 'with gametime timing' do
    it 'renders stats' do
      render(
        partial: 'runs/stats',
        locals: {
          run: run,
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_stats')
    end
  end
end
