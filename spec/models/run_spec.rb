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
      expect(run.segments.map { |s| [s.name, s.duration_milliseconds] }).to match_array [
        ['Tron City', 53921],
        ['Start Abraxas fight', 185453],
        ['Finish Abraxas fight', 108446],
        ['"FLYNN!"', 151874],
        ['"Hey! Over here!"', 117067],
        ['"That was CLU. I saw him." (stack2 skip inc)', 44819],
        ['"Follow me."', 114844],
        ['End of cycle ride (bridge skip inc)', 75843],
        ['End of bridge thing', 431475],
        ['Da Vinci', 18882],
        ['"Hey! Over here!" #2', 418688],
        ['Drive tank 4 feet', 372653],
        ['Green guy', 283038],
        ['Beat games', 186848],
        ['Green guy talks to me', 120515],
        ['Get across that bridge', 484387],
        ['Jump up and down on three lightsabers', 109862],
        ['"That\'s Flynn\'s!"', 43737],
        ['Race green guy', 67095],
        ['Kill green guy', 220725],
        ['Jump the bike', 278102],
        ['Grab me by the arm', 224736],
        ["Popcorn ceiling's revenge", 108322],
        ['Jump onto the flying staple', 112977],
        ['Ride motorbike for 9 seconds', 447303],
        ['Final fight phase 1', 59785],
        ['Final fight phase 2', 185817],
        ['Final fight phase 3', 28333]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration_milliseconds]).to eq [
        'Da Vinci', 18882
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration_milliseconds]).to eq [
        'Get across that bridge', 484387
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_milliseconds).to eq 118791
    end

    it 'accurately reports its total playtime' do
      expect(run.total_playtime_milliseconds).to eq 77743500
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
      expect(run.splits.map { |s| [s.name, s.duration_milliseconds] }).to eq [
        ['Hole 1', 30349],
        ['Hole 2', 42742],
        ['Hole 3', 35263],
        ['Hole 4', 25165],
        ['Hole 5', 34340],
        ['Hole 6', 34972],
        ['Hole 7', 20754],
        ['Hole 8', 41221],
        ['Hole 9', 43621],
        ['Hole 10', 28661],
        ['Hole 11', 37146],
        ['Hole 12', 62913],
        ['Hole 13', 41539],
        ['Hole 14', 35332],
        ['Hole 15', 36653],
        ['Hole 16', 31277],
        ['Hole 17', 37631],
        ['Hole 18', 66083]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration_milliseconds] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration_milliseconds]).to eq [
        'Hole 7', 20754
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration_milliseconds]).to eq [
        'Hole 18', 66083
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_milliseconds).to eq 35992
    end

    it 'accurately reports its total playtime' do
      expect(run.total_playtime_milliseconds).to eq 22450448
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
      expect(run.splits.map { |s| [s.name, s.duration_milliseconds] }).to eq [
        ['Spiral Mountain', 211230],
        ["Mumbo's Mountain", 808200]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits.map { |s| [s.name, s.duration_milliseconds] }).to eq []
    end

    it 'accurately reports its shortest segment' do
      expect([run.shortest_segment.name, run.shortest_segment.duration_milliseconds]).to eq [
        'Spiral Mountain', 211230
      ]
    end

    it 'accurately reports its longest segment' do
      expect([run.longest_segment.name, run.longest_segment.duration_milliseconds]).to eq [
        "Mumbo's Mountain", 808200
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_milliseconds).to eq(509715)
    end

    it 'accurately reports its total playtime' do
      expect(run.total_playtime_milliseconds).to eq 0
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
      expect(run.splits.map { |s| [s.name, s.duration_milliseconds] }).to eq [
        ["1-1", 32180],
        ["1-2", 31470],
        ["4-1", 37400],
        ["4-2", 29390],
        ["Pipe Jump City", 51030],
        ["Jumping Koopas", 37030],
        ["Count To 4", 35310],
        ["Hammers of Fortune", 46080]
      ]
    end

    context 'with reference attributes' do
      let(:run) do
        FactoryGirl.create(:llanfair_gered_run)
      end

      it 'has the correct splits' do
        expect(run.splits.map { |s| [s.name, s.duration_milliseconds] }).to eq [
          ["1-1", 32180],
          ["1-2", 31470],
          ["4-1", 37400],
          ["4-2", 29390],
          ["Pipe Jump City", 51030],
          ["Jumping Koopas", 37030],
          ["Count To 4", 35310],
          ["Hammers of Fortune", 46080]
        ]
      end

      it 'accurately reports its total playtime' do
        expect(run.total_playtime_milliseconds).to eq 0
      end
    end
  end

  context 'from WSplit' do
    let(:run) do
      FactoryGirl.create(:wsplit_run)
    end

    it 'has the correct splits' do
      expect(run.splits.map { |s| [s.name, s.duration_milliseconds] }).to eq [
        ["Introduction", 85480],
        ["Jimmy", 134200],
        ["Mona", 124070],
        ["Dribbles", 248240],
        ["9-Volt", 142990],
        ["Jimmy", 161370],
        ["Dr.Crygonal", 157080],
        ["Orbulon", 187270],
        ["Kat", 221980],
        ["Jimmy", 177610],
        ["Wario", 234060]
      ]
    end

    it 'accurately reports its total playtime' do
      expect(run.total_playtime_milliseconds).to eq 0
    end
  end
end
