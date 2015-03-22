require 'rails_helper'

describe Run, type: :model do
  let(:run) do
    Run.create!(run_file: RunFile.for_file(File.open("#{Rails.root}/spec/examples/livesplit_1")))
  end
  it "responds to base 36 id requests" do
    expect(run.id36).to eq(run.id.to_s(36))
  end
end
