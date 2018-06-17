require 'rails_helper'

RSpec.describe 'runs/_timeline_inspector' do
  let(:run) do
    r = FactoryBot.create(:livesplit16_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'with realtime timing' do
    it 'renders the timeline inspector' do
      render(
        partial: 'runs/timeline_inspector',
        locals: {
          run: run,
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_timeline_inspector')
    end
  end

  context 'with gametime timing' do
    it 'renders the timeline inspector' do
      render(
        partial: 'runs/timeline_inspector',
        locals: {
          run: run,
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_timeline_inspector')
    end
  end
end
