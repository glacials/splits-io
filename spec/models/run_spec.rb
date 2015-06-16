require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryGirl.create(:run) }

  it "responds to base 36 id requests" do
    expect(run.id36).to eq(run.id.to_s(36))
  end

  context "run with a valid video URL to a non-valid location" do
    let(:run) { FactoryGirl.build(:run, video_url: "http://google.com/") }

    it "fails to validate" do
      expect(run).to_not be_valid
    end
  end

  context "run with an invalid video URL" do
    let(:run) { FactoryGirl.build(:run, video_url: "Huge improvement. That King Boo fight tho... :/ 4 HP strats!") }

    it "fails to validate" do
      expect(run).to_not be_valid
    end
  end
end
