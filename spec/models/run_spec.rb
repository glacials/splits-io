require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryGirl.create(:run) }

  it 'responds to base 36 id requests' do
    expect(run.id36).to eq(run.id.to_s(36))
  end

  context 'run with a valid video URL to a non-valid location' do
    let(:run) { FactoryGirl.build(:run, video_url: 'http://google.com/') }

    it 'fails to validate' do
      expect(run).not_to be_valid
    end
  end

  context 'run with an invalid video URL' do
    let(:run) { FactoryGirl.build(:run, video_url: 'Huge improvement. That King Boo fight tho... :/ 4 HP strats!') }

    it 'fails to validate' do
      expect(run).not_to be_valid
    end
  end

  context 'new run' do
    it 'has a non-nil claim token' do
      expect(run.claim_token).not_to eq(nil)
    end
  end

  context 'LiveSplit run with file format 1.4.2' do
    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration] }).to eq([
          ["Tron City", 53.9219256],
          ["Start Abraxas fight", 185.4531417],
          ["Finish Abraxas fight", 108.44651289999996],
          ["\"FLYNN!\"", 151.87429940000004],
          ["\"Hey! Over here!\"", 117.06788499999993],
          ["\"That was CLU. I saw him.\" (stack2 skip inc)", 44.8199194],
          ["\"Follow me.\"", 114.84480970000004],
          ["End of cycle ride (bridge skip inc)", 75.84340850000001],
          ["End of bridge thing", 431.47512070000005],
          ["Da Vinci", 18.88231840000003],
          ["\"Hey! Over here!\" #2", 418.688498],
          ["Drive tank 4 feet", 372.6532138],
          ["Green guy", 283.0389589000001],
          ["Beat games", 186.84879569999976],
          ["Green guy talks to me", 120.51536669999996],
          ["Get across that bridge", 484.3879244],
          ["Jump up and down on three lightsabers", 109.8629691000001],
          ["\"That's Flynn's!\"", 43.73782930000016],
          ["Race green guy", 67.09577760000002],
          ["Kill green guy", 220.72551559999965],
          ["Jump the bike", 278.10209810000015],
          ["Grab me by the arm", 224.73634189999984],
          ["Popcorn ceiling's revenge", 108.32244480000008],
          ["Jump onto the flying staple", 112.97768619999988],
          ["Ride motorbike for 9 seconds", 447.3030593000003],
          ["Final fight phase 1", 59.78528019999976],
          ["Final fight phase 2", 185.81795669999974],
          ["Final fight phase 3", 28.333972000000358]
      ])
    end

    it 'accurately reports its missed splits' do
      expect(run.missed_splits.map { |s| [s.name, s.duration] }).to eq([])
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration]).to eq(
        ["Da Vinci", 18.88231840000003]
      )
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration]).to eq(
        ["Get across that bridge", 484.3879244]
      )
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration).to eq(118.79162584999995)
    end
  end
end
