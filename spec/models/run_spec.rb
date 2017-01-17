require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryGirl.create(:run) }

  context 'with a game' do
    context 'that has no other runs' do
      let(:run) { FactoryGirl.create(:run, game: FactoryGirl.create(:game)) }

      it "doesn't destroy its game when destroyed" do
        game = run.game
        run.destroy
        expect(game.destroyed?).to be false
      end
    end

    context 'that has other runs' do
      let(:run) do
        game = FactoryGirl.create(:game)
        FactoryGirl.create(:run, game: game)
        FactoryGirl.create(:run, game: game)
      end

      it "doesn't destroy its game when destroyed" do
        game = run.game
        run.destroy
        expect(game.destroyed?).to be false
      end
    end
  end

  context 'with a run_file' do
    context "that doesn't belong to other runs" do
      let(:run) { FactoryGirl.create(:run) }

      before do
        Run.destroy_all
      end

      it 'destroys its run_file when destroyed' do
        run_file = run.run_file
        run.destroy

        expect(run_file.destroyed?).to be true
      end
    end

    context 'that belongs to other runs' do
      let(:run) do
        run_file = RunFile.for_file(File.open("#{Rails.root}/spec/factories/run_files/livesplit1.4"))
        FactoryGirl.create(:run, run_file: run_file)
        FactoryGirl.create(:run, run_file: run_file)
      end

      it "doesn't destroy its run_file when destroyed" do
        run_file = run.run_file
        run.destroy

        expect(run_file.destroyed?).to be false
      end
    end
  end

  context 'with no owner' do
    context 'with an srdc_id' do
      let(:run) { FactoryGirl.create(:speedrundotcom_run) }

      before do
        expect(SpeedrunDotCom::Run).to receive(:runner_id).with(run.srdc_id).and_return(0)
        expect(SpeedrunDotCom::User).to receive(:twitch_login).with(0).and_return('glacials')
      end

      it 'tries to fetch its runner from speedrun.com' do
        run.set_runner_from_srdc
      end
    end
  end

  context 'with a valid video URL to a non-valid location' do
    let(:run) { FactoryGirl.build(:run, video_url: 'http://google.com/') }

    it 'fails to validate' do
      expect(run).not_to be_valid
    end
  end

  context 'with an invalid video URL' do
    let(:run) { FactoryGirl.build(:run, video_url: 'Huge improvement. That King Boo fight tho... :/ 4 HP strats!') }

    it 'fails to validate' do
      expect(run).not_to be_valid
    end
  end

  context 'just created' do
    it 'has a non-nil claim token' do
      expect(run.claim_token).not_to be_nil
    end
  end

  context 'from LiveSplit 1.4' do
    let(:run) do
      FactoryGirl.create(:livesplit1_4_run)
    end

    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration] }).to eq [
        ['Tron City', 53.9219256],
        ['Start Abraxas fight', 185.4531417],
        ['Finish Abraxas fight', 108.44651289999996],
        ['"FLYNN!"', 151.87429940000004],
        ['"Hey! Over here!"', 117.06788499999993],
        ['"That was CLU. I saw him." (stack2 skip inc)', 44.8199194],
        ['"Follow me."', 114.84480970000004],
        ['End of cycle ride (bridge skip inc)', 75.84340850000001],
        ['End of bridge thing', 431.47512070000005],
        ['Da Vinci', 18.88231840000003],
        ['"Hey! Over here!" #2', 418.688498],
        ['Drive tank 4 feet', 372.6532138],
        ['Green guy', 283.0389589000001],
        ['Beat games', 186.84879569999976],
        ['Green guy talks to me', 120.51536669999996],
        ['Get across that bridge', 484.3879244],
        ['Jump up and down on three lightsabers', 109.8629691000001],
        ['"That\'s Flynn\'s!"', 43.73782930000016],
        ['Race green guy', 67.09577760000002],
        ['Kill green guy', 220.72551559999965],
        ['Jump the bike', 278.10209810000015],
        ['Grab me by the arm', 224.73634189999984],
        ["Popcorn ceiling's revenge", 108.32244480000008],
        ['Jump onto the flying staple', 112.97768619999988],
        ['Ride motorbike for 9 seconds', 447.3030593000003],
        ['Final fight phase 1', 59.78528019999976],
        ['Final fight phase 2', 185.81795669999974],
        ['Final fight phase 3', 28.333972000000358]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration]).to eq [
        'Da Vinci', 18.88231840000003
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration]).to eq [
        'Get across that bridge', 484.3879244
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration).to eq 118.79162584999995
    end

    it 'reports no history using fast parsing' do
      expect(run.parse(fast: true)[:history]).to be_nil
    end

    it 'reports correct history when using slow parsing' do
      expect(run.parse(fast: false)[:history]).to eq [
        6911.1422649, 6261.793028, 6123.6647933, 5944.5159323, 5694.8238343, 5410.1111281, 5746.1888454, 5390.4596715,
        5258.0010184, 5236.1128949, 5102.848171, 5126.4048091, 5055.5630296
      ]
    end
  end

  context 'from LiveSplit 1.6' do
    let(:run) do
      FactoryGirl.create(:livesplit1_6_run)
    end

    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration] }).to eq [
        ['Hole 1', 30.349],
        ['Hole 2', 42.742999999999995],
        ['Hole 3', 35.263999999999996],
        ['Hole 4', 25.16500000000002],
        ['Hole 5', 34.34099999999998],
        ['Hole 6', 34.97200000000001],
        ['Hole 7', 20.754999999999995],
        ['Hole 8', 41.22199999999998],
        ['Hole 9', 43.62100000000004],
        ['Hole 10', 28.661999999999978],
        ['Hole 11', 37.146000000000015],
        ['Hole 12', 62.91300000000001],
        ['Hole 13', 41.539999999999964],
        ['Hole 14', 35.33299999999997],
        ['Hole 15', 36.65300000000002],
        ['Hole 16', 31.277000000000044],
        ['Hole 17', 37.63199999999995],
        ['Hole 18', 66.08300000000008]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration]).to eq [
        'Hole 7', 20.754999999999995
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration]).to eq [
        'Hole 18', 66.08300000000008
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration).to eq 35.992999999999995
    end

    it 'reports no history using fast parsing' do
      expect(run.parse(fast: true)[:history]).to be_nil
    end

    it 'reports correct history when using slow parsing' do
      expect(run.parse(fast: false)[:history]).to eq [
        912.296, 859.304, 801.458, 755.249, 793.755, 744.211, 741.924, 815.122, 761.782, 696.49, 710.935, 727.007,
        715.404, 730.922, 705.515, 728.286, 714.258, 705.742, 691.061, 685.671
      ]
    end
  end

  context 'from Llanfair' do
    let(:run) do
      FactoryGirl.create(:llanfair_run)
    end

    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration] }).to eq [
        ['Spiral Mountain', 211.23],
        ["Mumbo's Mountain", 808.2]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration]).to eq [
        'Spiral Mountain', 211.23
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration]).to eq [
        "Mumbo's Mountain", 808.2
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration).to eq(509.71500000000003)
    end

    it 'correctly converts back to llanfair files' do
      run.program = :llanfair
      expect(run.original_file).to eq(RunFile.pack_binary(run.file))
    end
  end

  context 'from the Gered Llanfair fork' do
    let(:run) do
      FactoryGirl.create(:llanfair_gered_run)
    end

    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration.to_f] }).to eq [
        ["1-1", 32.18],
        ["1-2", 31.47],
        ["4-1", 37.40],
        ["4-2", 29.39],
        ["Pipe Jump City", 51.03],
        ["Jumping Koopas", 37.03],
        ["Count To 4", 35.31],
        ["Hammers of Fortune", 46.08]
      ]
    end

    context 'with reference attributes' do
      let(:run) do
        FactoryGirl.create(:llanfair_gered_run)
      end
      it 'has the correct splits' do
        expect(run.splits.map { |s| [s.name, s.duration.to_f] }).to eq [
          ["1-1", 32.18],
          ["1-2", 31.47],
          ["4-1", 37.4],
          ["4-2", 29.39],
          ["Pipe Jump City", 51.03],
          ["Jumping Koopas", 37.03],
          ["Count To 4", 35.31],
          ["Hammers of Fortune", 46.08]
        ]
      end
    end
  end
end
