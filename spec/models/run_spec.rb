require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryGirl.create(:run) }

  context 'with a game' do
    context 'that has no other runs' do
      let(:run) do
        FactoryGirl.create(:run, game: FactoryGirl.create(:game))
      end

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

  context 'with a category' do
    context 'with other runs' do
      let(:category) { FactoryGirl.create(:category) }
      let(:run) { FactoryGirl.create(:run, category: category) }
      let(:other_run) { FactoryGirl.create(:run, category: category) }

      it 'can be compared against' do
        run.improvements_towards(other_run)
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
    let(:run) do
      FactoryGirl.build(:run, video_url: 'Huge improvement. That King Boo fight tho... :/ 4 HP strats!')
    end

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
      r = FactoryGirl.create(:livesplit14_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Tron City', 53921],
        [1, 'Start Abraxas fight', 185453],
        [2, 'Finish Abraxas fight', 108446],
        [3, '"FLYNN!"', 151874],
        [4, '"Hey! Over here!"', 117067],
        [5, '"That was CLU. I saw him." (stack2 skip inc)', 44819],
        [6, '"Follow me."', 114844],
        [7, 'End of cycle ride (bridge skip inc)', 75843],
        [8, 'End of bridge thing', 431475],
        [9, 'Da Vinci', 18882],
        [10, '"Hey! Over here!" #2', 418688],
        [11, 'Drive tank 4 feet', 372653],
        [12, 'Green guy', 283038],
        [13, 'Beat games', 186848],
        [14, 'Green guy talks to me', 120515],
        [15, 'Get across that bridge', 484387],
        [16, 'Jump up and down on three lightsabers', 109862],
        [17, '"That\'s Flynn\'s!"', 43737],
        [18, 'Race green guy', 67095],
        [19, 'Kill green guy', 220725],
        [20, 'Jump the bike', 278102],
        [21, 'Grab me by the arm', 224736],
        [22, "Popcorn ceiling's revenge", 108322],
        [23, 'Jump onto the flying staple', 112977],
        [24, 'Ride motorbike for 9 seconds', 447303],
        [25, 'Final fight phase 1', 59785],
        [26, 'Final fight phase 2', 185817],
        [27, 'Final fight phase 3', 28333]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        9, 'Da Vinci', 18882
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        15, 'Get across that bridge', 484387
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 118791
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 77743500
    end

    it 'reports no history using fast parsing' do
      expect(run.parse(fast: true)[:realtime_history]).to be_nil
    end

    it 'reports correct history when using slow parsing' do
      expect(run.parse(fast: false)[:realtime_history]).to match_array [
        6911.1422649, 6261.793028, 6123.6647933, 5944.5159323, 5694.8238343, 5410.1111281, 5746.1888454, 5390.4596715,
        5258.0010184, 5236.1128949, 5102.848171, 5126.4048091, 5055.5630296
      ]
    end
  end

  context 'from LiveSplit 1.5' do
    let(:run) do
      r = FactoryGirl.create(:livesplit15_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, "Green Greens", 99390],
        [1, "Castle LoLoLo", 91940],
        [2, "Float Islands", 127809],
        [3, "Bubbly Clouds", 195180],
        [4, "Mt. DeDeDe", 236439],
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        1, "Castle LoLoLo", 91940
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        4, 'Mt. DeDeDe', 236439
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 127809
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 0
    end

    it 'reports no history using fast parsing' do
      expect(run.parse(fast: true)[:realtime_history]).to be_nil
    end

    it 'reports correct history when using slow parsing' do
      expect(run.parse(fast: false)[:realtime_history]).to match_array [
        823.1730805
      ]
    end
  end

  context 'from LiveSplit 1.6' do
    let(:run) do
      r = FactoryGirl.create(:livesplit16_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Hole 1', 30349],
        [1, 'Hole 2', 42742],
        [2, 'Hole 3', 35263],
        [3, 'Hole 4', 25165],
        [4, 'Hole 5', 34340],
        [5, 'Hole 6', 34972],
        [6, 'Hole 7', 20754],
        [7, 'Hole 8', 41221],
        [8, 'Hole 9', 43621],
        [9, 'Hole 10', 28661],
        [10, 'Hole 11', 37146],
        [11, 'Hole 12', 62913],
        [12, 'Hole 13', 41539],
        [13, 'Hole 14', 35332],
        [14, 'Hole 15', 36653],
        [15, 'Hole 16', 31277],
        [16, 'Hole 17', 37631],
        [17, 'Hole 18', 66083]
      ]
    end

    it 'accurately reports its missed splits' do
      rss = run.skipped_splits(Run::REAL)
      expect(rss.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        6, 'Hole 7', 20754
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        17, 'Hole 18', 66083
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 35992
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 22450448
    end

    it 'reports no history using fast parsing' do
      expect(run.parse(fast: true)[:realtime_history]).to be_nil
    end

    it 'reports correct history when using slow parsing' do
      expect(run.parse(fast: false)[:realtime_history]).to match_array [
        912.296, 859.304, 801.458, 755.249, 793.755, 744.211, 741.924, 815.122, 761.782, 696.49, 710.935, 727.007,
        715.404, 730.922, 705.515, 728.286, 714.258, 705.742, 691.061, 685.671
      ]
    end

    context 'with game time' do
      let(:run) do
        r = FactoryGirl.create(:livesplit16_gametime_run)
        r.parse_into_activerecord
        r.reload
        r
      end

      it 'has the correct realtime segments' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
          [0, "WatchYr<3Die", 191265],
          [1, "Elevator Land", 73595],
          [2, "Gross, Rats", 131065],
          [3, "Try Not Falling?", 232498],
          [4, "Men of the Faith", 147284],
          [5, "Fuckin Celia", 118806],
          [6, "Tr4p Haus", 171703],
          [7, "Troubled Waters", 305158],
          [8, "RNG Roulette", 215579],
          [9, "Not At Fault", 246412],
          [10, "Amateur Work", 377836],
          [11, "Don't Mind Me", 67085],
          [12, "H9 U Havelock", 123226],
        ]
      end

      it 'has the correct gametime segments' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::GAME)] }).to match_array [
          [0, "WatchYr<3Die", 191265],
          [1, "Elevator Land", 71271],
          [2, "Gross, Rats", 127293],
          [3, "Try Not Falling?", 220780],
          [4, "Men of the Faith", 134083],
          [5, "Fuckin Celia", 107779],
          [6, "Tr4p Haus", 159324],
          [7, "Troubled Waters", 287640],
          [8, "RNG Roulette", 196420],
          [9, "Not At Fault", 231033],
          [10, "Amateur Work", 355115],
          [11, "Don't Mind Me", 59727],
          [12, "H9 U Havelock", 116235]
        ]
      end
    end
  end

  context 'from Llanfair' do
    let(:run) do
      r = FactoryGirl.create(:llanfair_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Spiral Mountain', 211230],
        [1, "Mumbo's Mountain", 808200]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        0, 'Spiral Mountain', 211230
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        1, "Mumbo's Mountain", 808200
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq(509715)
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 0
    end
  end

  context 'from the Gered Llanfair fork' do
    let(:run) do
      r = FactoryGirl.create(:llanfair_gered_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, "1-1", 32180],
        [1, "1-2", 31470],
        [2, "4-1", 37400],
        [3, "4-2", 29390],
        [4, "Pipe Jump City", 51030],
        [5, "Jumping Koopas", 37030],
        [6, "Count To 4", 35310],
        [7, "Hammers of Fortune", 46080]
      ]
    end

    context 'with reference attributes' do
      let(:run) do
        r = FactoryGirl.create(:llanfair_gered_run)
        r.parse_into_activerecord
      r.reload
        r
      end

      it 'has the correct splits' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
          [0, "1-1", 32180],
          [1, "1-2", 31470],
          [2, "4-1", 37400],
          [3, "4-2", 29390],
          [4, "Pipe Jump City", 51030],
          [5, "Jumping Koopas", 37030],
          [6, "Count To 4", 35310],
          [7, "Hammers of Fortune", 46080]
        ]
      end

      it 'reports its total playtime' do
        expect(run.total_playtime_ms(Run::REAL)).to eq 0
      end
    end
  end

  context 'from WSplit' do
    let(:run) do
      r = FactoryGirl.create(:wsplit_run)
      r.parse_into_activerecord
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, "Introduction", 85480],
        [1, "Jimmy", 134200],
        [2, "Mona", 124070],
        [3, "Dribbles", 248240],
        [4, "9-Volt", 142990],
        [5, "Jimmy", 161370],
        [6, "Dr.Crygonal", 157080],
        [7, "Orbulon", 187270],
        [8, "Kat", 221980],
        [9, "Jimmy", 177610],
        [10, "Wario", 234060]
      ]
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 0
    end
  end

  context 'from Time Split Tracker' do
    let(:run) do
      r = FactoryGirl.create(:timesplittracker_run)
      r.parse_into_activerecord
      r.reload
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, "Hyrule Castle", 377060],
        [1, "Eastern Palace", 353060],
        [2, "Desert Palace", 467070],
        [3, "Tower of hera", 478079],
        [4, "Light World", 565099],
        [5, "Dark Palace", 445070],
        [6, "Dig", 459079],
        [7, "Chest", 331050],
        [8, "Thieves’ Town", 327159],
        [9, "Skull Woods", 491400],
        [10, "Ice Palace", 561750],
        [11, "Misery Mire", 655769],
        [12, "Swamp Palace", 599410],
        [13, "Turtle Rock", 1115179],
        [14, "Dark World", 686119],
        [15, "Triforce", 133640]
      ]
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms(Run::REAL)).to eq 0
    end
  end
end
