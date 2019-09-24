require 'rails_helper'

describe Run, type: :model do
  let(:run) { FactoryBot.create(:run) }

  context 'with no file' do
    it 'returns nil' do
      run.s3_filename = SecureRandom.uuid
      expect(run.file).to be nil
    end
  end

  context 'with a game' do
    context 'that has no other runs' do
      let(:run) do
        FactoryBot.create(:run, game: FactoryBot.create(:game))
      end

      it "doesn't destroy its game when destroyed" do
        game = run.game
        run.destroy
        expect(game.destroyed?).to be false
      end
    end

    context 'that has other runs' do
      let(:run) do
        game = FactoryBot.create(:game)
        FactoryBot.create(:run, game: game)
        FactoryBot.create(:run, game: game)
      end

      it "doesn't destroy its game when destroyed" do
        game = run.game
        run.destroy
        expect(game.destroyed?).to be false
      end
    end
  end

  context 'with no realtime' do
    let(:run) do
      run = FactoryBot.create(:livesplit_no_realtime_run)
      run.parse_into_db
      run
    end

    it 'sets its timing to gametime' do
      expect(run.default_timing).to eq Run::GAME
    end
  end

  context 'with a category' do
    context 'with other runs' do
      let(:category) { FactoryBot.create(:category) }
      let(:run) { FactoryBot.create(:run, category: category) }
      let(:other_run) { FactoryBot.create(:run, category: category) }

      it 'can be compared against' do
        run.improvements_towards(Run::REAL, other_run)
      end
    end
  end

  context 'with no owner' do
    context 'with an srdc_id' do
      let(:run) { FactoryBot.create(:speedrundotcom_run) }

      before do
        expect(SpeedrunDotCom::Run).to receive(:runner_id).with(run.srdc_id).and_return(0)
        expect(SpeedrunDotCom::User).to receive(:twitch_login).with(0).and_return('glacials')
      end

      it 'tries to fetch its runner from speedrun.com' do
        DiscoverRunnerJob.perform_now(run)
      end
    end
  end

  context 'just created' do
    it 'has a non-nil claim token' do
      expect(run.claim_token).not_to be_nil
    end
  end

  context 'with bests in all segments' do
    let(:run) { FactoryBot.create(:with_segments_bests_run) }

    it 'has a realtime sum of best in ms' do
      run.parse_into_db
      run.reload

      # Float values get truncated when saved to the database, so there can be
      # a difference between the individually truncated number of ms saved on
      # each segment vs the whole sum which is first sumed up as floats and *then*
      # truncated. That's why there can be a difference up to the number of segments
      # present and we need to use `be_within`.
      expect(run.realtime_sum_of_best_ms).to be_within(run.segments.count)
        .of(run.segments.map(&:realtime_shortest_duration_ms).sum)
    end

    it 'has a gametime sum of best in ms' do
      run.parse_into_db
      run.reload
      expect(run.gametime_sum_of_best_ms).to be_within(run.segments.count)
        .of(run.segments.map(&:gametime_shortest_duration_ms).sum)
    end
  end

  context 'from LiveSplit 1.4' do
    let(:run) do
      r = FactoryBot.create(:livesplit14_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Tron City', 53_921],
        [1, 'Start Abraxas fight', 185_453],
        [2, 'Finish Abraxas fight', 108_446],
        [3, '"FLYNN!"', 151_874],
        [4, '"Hey! Over here!"', 117_067],
        [5, '"That was CLU. I saw him." (stack2 skip inc)', 44_819],
        [6, '"Follow me."', 114_844],
        [7, 'End of cycle ride (bridge skip inc)', 75_843],
        [8, 'End of bridge thing', 431_475],
        [9, 'Da Vinci', 18_882],
        [10, '"Hey! Over here!" #2', 418_688],
        [11, 'Drive tank 4 feet', 372_653],
        [12, 'Green guy', 283_038],
        [13, 'Beat games', 186_848],
        [14, 'Green guy talks to me', 120_515],
        [15, 'Get across that bridge', 484_387],
        [16, 'Jump up and down on three lightsabers', 109_862],
        [17, '"That\'s Flynn\'s!"', 43_737],
        [18, 'Race green guy', 67_095],
        [19, 'Kill green guy', 220_725],
        [20, 'Jump the bike', 278_102],
        [21, 'Grab me by the arm', 224_736],
        [22, "Popcorn ceiling's revenge", 108_322],
        [23, 'Jump onto the flying staple', 112_977],
        [24, 'Ride motorbike for 9 seconds', 447_303],
        [25, 'Final fight phase 1', 59_785],
        [26, 'Final fight phase 2', 185_817],
        [27, 'Final fight phase 3', 28_333]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        9, 'Da Vinci', 18_882
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        15, 'Get across that bridge', 484_387
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 118_791
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 77_067_132
    end

    it 'reports the correct history' do
      expect(run.histories.map(&:realtime_duration_ms).reject(&:nil?)).to match_array [
        6_911_142, 6_261_793, 6_123_664, 5_944_515, 5_694_823, 5_410_111, 5_746_188,
        5_390_459, 5_258_001, 5_236_112, 5_102_848, 5_126_404, 5_055_563
      ]
    end
  end

  context 'from LiveSplit 1.5' do
    let(:run) do
      r = FactoryBot.create(:livesplit15_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Green Greens', 99_390],
        [1, 'Castle LoLoLo', 91_940],
        [2, 'Float Islands', 127_810],
        [3, 'Bubbly Clouds', 195_180],
        [4, 'Mt. DeDeDe', 236_439]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        1, 'Castle LoLoLo', 91_940
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        4, 'Mt. DeDeDe', 236_439
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 127_810
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 2_870_198
    end

    it 'reports the correct history' do
      expect(run.histories.map(&:realtime_duration_ms).reject(&:nil?)).to match_array [
        823_173
      ]
    end
  end

  context 'from LiveSplit 1.6' do
    let(:run) do
      r = FactoryBot.create(:livesplit16_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Hole 1', 30_349],
        [1, 'Hole 2', 42_743],
        [2, 'Hole 3', 35_264],
        [3, 'Hole 4', 25_165],
        [4, 'Hole 5', 34_341],
        [5, 'Hole 6', 34_972],
        [6, 'Hole 7', 20_755],
        [7, 'Hole 8', 41_221],
        [8, 'Hole 9', 43_621],
        [9, 'Hole 10', 28_662],
        [10, 'Hole 11', 37_146],
        [11, 'Hole 12', 62_913],
        [12, 'Hole 13', 41_540],
        [13, 'Hole 14', 35_332],
        [14, 'Hole 15', 36_653],
        [15, 'Hole 16', 31_277],
        [16, 'Hole 17', 37_632],
        [17, 'Hole 18', 66_083]
      ]
    end

    it 'accurately reports its missed splits' do
      rss = run.skipped_splits(Run::REAL)
      expect(rss.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        6, 'Hole 7', 20_755
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        17, 'Hole 18', 66_083
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq 35_992
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 23_676_000
    end

    it 'reports the correct history' do
      expect(run.histories.map(&:realtime_duration_ms).reject(&:nil?)).to match_array [
        912_296, 859_304, 801_458, 755_249, 793_755, 744_211, 741_924, 815_122, 761_782, 696_490,
        710_935, 727_007, 715_404, 730_922, 705_515, 728_286, 714_258, 705_742, 691_061, 685_671
      ]
    end

    it 'reports correct history after parsing twice' do
      run.parse_into_db
      run.parse_into_db
      run.reload

      expect(run.histories.count).to eq(55)
    end

    context 'with game time' do
      let(:run) do
        r = FactoryBot.create(:livesplit16_gametime_run)
        r.parse_into_db
        r.reload
        r
      end

      it 'has the correct realtime segments' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
          [0, 'WatchYr<3Die', 191_265],
          [1, 'Elevator Land', 73_595],
          [2, 'Gross, Rats', 131_065],
          [3, 'Try Not Falling?', 232_498],
          [4, 'Men of the Faith', 147_285],
          [5, 'Fuckin Celia', 118_806],
          [6, 'Tr4p Haus', 171_703],
          [7, 'Troubled Waters', 305_159],
          [8, 'RNG Roulette', 215_580],
          [9, 'Not At Fault', 246_412],
          [10, 'Amateur Work', 377_836],
          [11, "Don't Mind Me", 67_086],
          [12, 'H9 U Havelock', 123_227]
        ]
      end

      it 'has the correct gametime segments' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::GAME)] }).to match_array [
          [0, 'WatchYr<3Die', 191_265],
          [1, 'Elevator Land', 71_271],
          [2, 'Gross, Rats', 127_293],
          [3, 'Try Not Falling?', 220_780],
          [4, 'Men of the Faith', 134_084],
          [5, 'Fuckin Celia', 107_779],
          [6, 'Tr4p Haus', 159_324],
          [7, 'Troubled Waters', 287_641],
          [8, 'RNG Roulette', 196_420],
          [9, 'Not At Fault', 231_033],
          [10, 'Amateur Work', 355_115],
          [11, "Don't Mind Me", 59_727],
          [12, 'H9 U Havelock', 116_236]
        ]
      end

      it 'has the correct realtime segment histories for the last segment' do
        expect(run.segments.last.histories.map { |s| s.duration_ms(Run::REAL) }).to match_array [
          126_655, 124_846, 155_191, 140_486, 122_007, 143_338, 132_288, 123_207, 177_090, 164_684, 145_047,
          123_260, 125_012, 147_050, 126_685, 128_863, 141_873, 141_239, 157_672, 136_347, 145_621, 139_113, 148_362,
          146_256, 125_921, 123_539, 129_806, 138_700, 141_579, 149_764
        ]
      end

      it 'has the correct gametime segment histories for the last segment' do
        expect(run.segments.last.histories.map { |s| s.duration_ms(Run::GAME) }).to match_array [
          120_240, 117_973, 143_557, 129_113, 115_471, 129_568, 120_883, 116_759, 153_910, 140_808, 129_495,
          115_616, 119_535, 118_088, 120_402, 121_371, 125_620, 129_508, 138_559, 125_248, 129_562, 120_974, 134_318,
          128_583, 118_413, 117_208, 119_309, 126_549, 135_392, 136_609
        ]
      end
    end
  end

  context 'from Llanfair' do
    let(:run) do
      r = FactoryBot.create(:llanfair_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Spiral Mountain', 211_230],
        [1, "Mumbo's Mountain", 808_200]
      ]
    end

    it 'accurately reports its missed splits' do
      expect(run.skipped_splits(Run::REAL).map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array []
    end

    it 'accurately reports its shortest segment' do
      rss = run.shortest_segment(Run::REAL)
      expect([rss.segment_number, rss.name, rss.duration_ms(Run::REAL)]).to match_array [
        0, 'Spiral Mountain', 211_230
      ]
    end

    it 'accurately reports its longest segment' do
      rls = run.longest_segment(Run::REAL)
      expect([rls.segment_number, rls.name, rls.duration_ms(Run::REAL)]).to match_array [
        1, "Mumbo's Mountain", 808_200
      ]
    end

    it 'accurately reports its median segment duration' do
      expect(run.median_segment_duration_ms(Run::REAL)).to eq(509_715)
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 0
    end
  end

  context 'from the Gered Llanfair fork' do
    let(:run) do
      r = FactoryBot.create(:llanfair_gered_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, '1-1', 32_180],
        [1, '1-2', 31_470],
        [2, '4-1', 37_400],
        [3, '4-2', 29_390],
        [4, 'Pipe Jump City', 51_030],
        [5, 'Jumping Koopas', 37_030],
        [6, 'Count To 4', 35_310],
        [7, 'Hammers of Fortune', 46_080]
      ]
    end

    context 'with reference attributes' do
      let(:run) do
        r = FactoryBot.create(:llanfair_gered_run)
        r.parse_into_db
        r.reload
        r
      end

      it 'has the correct splits' do
        expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
          [0, '1-1', 32_180],
          [1, '1-2', 31_470],
          [2, '4-1', 37_400],
          [3, '4-2', 29_390],
          [4, 'Pipe Jump City', 51_030],
          [5, 'Jumping Koopas', 37_030],
          [6, 'Count To 4', 35_310],
          [7, 'Hammers of Fortune', 46_080]
        ]
      end

      it 'reports its total playtime' do
        expect(run.total_playtime_ms).to eq 0
      end
    end
  end

  context 'from WSplit' do
    let(:run) do
      r = FactoryBot.create(:wsplit_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Introduction', 85_480],
        [1, 'Jimmy', 134_200],
        [2, 'Mona', 124_070],
        [3, 'Dribbles', 248_240],
        [4, '9-Volt', 142_990],
        [5, 'Jimmy', 161_370],
        [6, 'Dr.Crygonal', 157_080],
        [7, 'Orbulon', 187_270],
        [8, 'Kat', 221_980],
        [9, 'Jimmy', 177_610],
        [10, 'Wario', 234_060]
      ]
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 0
    end
  end

  context 'from Time Split Tracker' do
    let(:run) do
      r = FactoryBot.create(:timesplittracker_run)
      r.parse_into_db
      r.reload
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, 'Hyrule Castle', 377_060],
        [1, 'Eastern Palace', 353_060],
        [2, 'Desert Palace', 467_070],
        [3, 'Tower of hera', 478_080],
        [4, 'Light World', 565_100],
        [5, 'Dark Palace', 445_070],
        [6, 'Dig', 459_080],
        [7, 'Chest', 331_050],
        [8, 'Thieves’ Town', 327_160],
        [9, 'Skull Woods', 491_400],
        [10, 'Ice Palace', 561_750],
        [11, 'Misery Mire', 655_770],
        [12, 'Swamp Palace', 599_410],
        [13, 'Turtle Rock', 1_115_180],
        [14, 'Dark World', 686_120],
        [15, 'Triforce', 133_640]
      ]
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 0
    end
  end

  context 'from the Splits.io Exchange Format' do
    let(:run) do
      r = FactoryBot.create(:splitsio_exchange_run)
      r.parse_into_db
      r.reload
      r.reload
      r
    end

    it 'has the correct splits' do
      expect(run.segments.map { |s| [s.segment_number, s.name, s.duration_ms(Run::REAL)] }).to match_array [
        [0, '1', 8247],
        [1, '2', 2115],
        [2, '3', 6014],
        [3, '4', 6766],
        [4, '5', 3172],
        [5, '6', 5785],
        [6, '7', 4190],
        [7, '8', 3935],
        [8, '9', 5793],
        [9, '10', 6318],
        [10, '11', 4719],
        [11, '12', 2650],
        [12, '13', 6549],
        [13, '14', 2078],
        [14, '15', 1207],
        [15, '16', 5542],
        [16, '17', 1386],
        [17, '18', 13_882],
        [18, '19', 9669],
        [19, '20', 5644],
        [20, '21', 3583],
        [21, '22', 5650],
        [22, '23', 5329],
        [23, '24', 5395],
        [24, '25', 5614],
        [25, '26', 8806],
        [26, '27', 4104],
        [27, '28', 9506],
        [28, '29', 15_658],
        [29, '30', 4756],
        [30, '31', 6542]
      ]
    end

    it 'reports its total playtime' do
      expect(run.total_playtime_ms).to eq 8_589_280
    end
  end

  context 'skipped splits stats' do
    let(:run) do
      r = FactoryBot.create(:skipped_splits_run)
      r.parse_into_db
      r.reload
      r
    end

    it 'has the correct stats' do
      stats = run.segment_history_stats(Run::REAL)
      ids = run.segments.order(:segment_number).map(&:id)

      expect(stats[ids[0]][:standard_deviation].to_f).to be_within(1)
                                                           .of(48_989)
      expect(stats[ids[0]][:mean].to_f).to eq 120_000
      expect(stats[ids[0]][:median].to_f).to eq 120_000
      expect(stats[ids[0]][:percentiles][10].to_f).to eq 72_000
      expect(stats[ids[0]][:percentiles][90].to_f).to eq 168_000
      expect(stats[ids[0]][:percentiles][99].to_f).to eq 178_800

      expect(stats[ids[1]][:standard_deviation].to_f).to be_within(1)
                                                           .of(450_000)
      expect(stats[ids[1]][:mean].to_f).to eq 1_950_000
      expect(stats[ids[1]][:median].to_f).to eq 1_500_000
      expect(stats[ids[1]][:percentiles][10].to_f).to eq 1_590_000
      expect(stats[ids[1]][:percentiles][90].to_f).to eq 2_310_000
      expect(stats[ids[1]][:percentiles][99].to_f).to eq 2_391_000

      expect(stats[ids[2]][:standard_deviation].to_f).to be_within(1)
                                                           .of(180_000)
      expect(stats[ids[2]][:mean].to_f).to eq 660_000
      expect(stats[ids[2]][:median].to_f).to eq 480_000
      expect(stats[ids[2]][:percentiles][10].to_f).to eq 516_000
      expect(stats[ids[2]][:percentiles][90].to_f).to eq 804_000
      expect(stats[ids[2]][:percentiles][99].to_f).to eq 836_400
    end
  end
end
