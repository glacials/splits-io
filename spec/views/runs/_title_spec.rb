require 'rails_helper'

RSpec.describe 'runs/_title' do
  let(:run) do
    r = FactoryBot.create(:livesplit16_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'a run with real time' do
    it 'renders the title template' do
      render(
        partial: 'runs/title',
        locals: {
          run: run,
          compare_runs: [],
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_title')
    end

    context 'with a comparison run' do
      it 'renders the title template' do
        render(
          partial: 'runs/title',
          locals: {
            run: run,
            compare_runs: [run],
            timing: Run::REAL
          }
        )

        expect(view).to render_template('runs/_title')
      end
    end
  end

  context 'a run with game time' do
    it 'renders the title template' do
      render(
        partial: 'runs/title',
        locals: {
          run: run,
          compare_runs: [],
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_title')
    end

    context 'with a comparison run' do
      it 'renders the title template' do
        render(
          partial: 'runs/title',
          locals: {
            run: run,
            compare_runs: [run],
            timing: Run::GAME
          }
        )

        expect(view).to render_template('runs/_title')
      end
    end
  end
end
