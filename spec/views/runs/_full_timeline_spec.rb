require 'rails_helper'

RSpec.describe 'runs/_full_timeline' do
  let(:run) do
    r = FactoryBot.create(:livesplit16_gametime_run)
    r.parse_into_db
    r.reload
    r
  end

  context 'with realtime timing' do
    it 'renders the full timeline' do
      render(
        partial: 'runs/full_timeline',
        locals: {
          run: run,
          compare_runs: [],
          timing: Run::REAL
        }
      )

      expect(view).to render_template('runs/_full_timeline')
    end

    context 'with a comparison run' do
      it 'renders the full timeline' do
        render(
          partial: 'runs/full_timeline',
          locals: {
            run: run,
            compare_runs: [run],
            timing: Run::REAL
          }
        )

        expect(view).to render_template('runs/_full_timeline')
      end
    end

    context 'with a comparison run with segment groups' do
      it 'renders the full timeline' do
        segment_group_run = FactoryBot.create(:subsplits_with_titles_run)
        segment_group_run.parse_into_db
        segment_group_run.reload

        render(
          partial: 'runs/full_timeline',
          locals: {
            run: segment_group_run,
            compare_runs: [segment_group_run],
            timing: Run::REAL
          }
        )

        expect(view).to render_template('runs/_full_timeline')
      end
    end
  end

  context 'with gametime timing' do
    it 'renders the full timeline' do
      render(
        partial: 'runs/full_timeline',
        locals: {
          run: run,
          compare_runs: [],
          timing: Run::GAME
        }
      )

      expect(view).to render_template('runs/_full_timeline')
    end

    context 'with a comparison run' do
      it 'renders the full timeline' do
        render(
          partial: 'runs/full_timeline',
          locals: {
            run: run,
            compare_runs: [run],
            timing: Run::GAME
          }
        )

        expect(view).to render_template('runs/_full_timeline')
      end
    end
  end
end
