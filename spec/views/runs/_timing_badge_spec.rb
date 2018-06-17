require 'rails_helper'

RSpec.describe 'runs/_timing_badge' do
  context 'a run with only realtime' do
    let(:run) do
      r = FactoryBot.create(:livesplit16_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'renders the timing badge' do
      render(
        partial: 'runs/timing_badge',
        locals: {
          run: run,
          timing: Run::REAL
        }
      )
    end
  end

  context 'a run with both realtime and gametime' do
    let(:run) do
      r = FactoryBot.create(:livesplit16_gametime_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'renders the timing badge' do
      render(
        partial: 'runs/timing_badge',
        locals: {
          run: run,
          timing: Run::GAME
        }
      )
    end
  end
end
