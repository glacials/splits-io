require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryGirl.create(:run) }

  it "responds to base 36 id requests" do
    expect(run.id36).to eq(run.id.to_s(36))
  end
end
