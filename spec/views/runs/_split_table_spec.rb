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
          run: run,
          compare_runs: [],
          short: run.short?(Run::REAL),
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_split_table')
    end

    context 'with a comparison run' do
      it 'renders the split table' do
        render(
          partial: 'runs/split_table',
          locals: {
            run: run,
            compare_runs: [run],
            short: run.short?(Run::REAL),
            timing: Run::REAL
          }
        )

        expect(view).to render_template('runs/_split_table')
      end
    end
  end

  context 'with gametime timing' do
    it 'renders the split table' do
      render(
        partial: 'runs/split_table',
        locals: {
          run: run,
          compare_runs: [],
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_split_table')
    end

    context 'with a comparison run' do
      it 'renders the split table' do
        render(
          partial: 'runs/split_table',
          locals: {
            run: run,
            compare_runs: [run],
            short: run.short?(Run::GAME),
            timing: Run::GAME
          }
        )

        expect(view).to render_template('runs/_split_table')
      end
    end
  end
end
