require 'rails_helper'

RSpec.describe Run, type: :model do
  context "recorded by LiveSplit" do
    it "responds to base 36 id requests" do
      run = Run.create!(
        run_file: RunFile.for_file(File.open('spec/examples/runs/livesplit_1.lss'))
      )
      expect(run.id36).to eq(run.id.to_s(36))
    end
  end
end
