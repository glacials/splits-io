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
          compared_run: nil,
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
            compared_run: run,
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
          compared_run: nil,
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
            compared_run: run,
            timing: Run::GAME
          }
        )

        expect(view).to render_template('runs/_full_timeline')
      end
    end
  end
end
