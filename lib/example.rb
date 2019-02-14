module Example
  class Run
    def self.example_run
      run = ::Run.new(
        id: 'example',
        attempts: 57,
        realtime_duration_ms: 4664116,
        realtime_sum_of_best_ms: 4105132,
        gametime_sum_of_best_ms: 4801708,
        default_timing: ::Run::REAL,
        total_playtime_ms: 159008132
      )

      run.segments << Segment.new(
        segment_number: 0,
        realtime_duration_ms: 52605,
        realtime_start_ms: 0,
        realtime_end_ms: 52605,
        realtime_shortest_duration_ms: 47178,
        name: "Tron City",
        realtime_gold: false,
        realtime_reduced: false,
        realtime_skipped: false
      )
      run.segments << Segment.new(
        segment_number: 1,
        realtime_duration_ms: 171953,
        realtime_start_ms: 52605,
        realtime_end_ms: 224558,
        realtime_shortest_duration_ms: 171953,
        name: "Start Abraxas fight",
        realtime_gold: true
      )
      run.segments << Segment.new(
        segment_number: 2,
        realtime_duration_ms: 105552,
        realtime_start_ms: 224558,
        realtime_end_ms: 330110,
        realtime_shortest_duration_ms: 103500,
        name: "Finish Abraxas fight",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 3,
        realtime_duration_ms: 166131,
        realtime_start_ms: 330110,
        realtime_end_ms: 496241,
        realtime_shortest_duration_ms: 151874,
        name: "\"FLYNN!\"",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 4,
        realtime_duration_ms: 113203,
        realtime_start_ms: 496241,
        realtime_end_ms: 609444,
        realtime_shortest_duration_ms: 104423,
        name: "\"Hey! Over here!\"",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 5,
        realtime_duration_ms: 42648,
        realtime_start_ms: 609444,
        realtime_end_ms: 652092,
        realtime_shortest_duration_ms: 42388,
        name: "\"That was CLU. I saw him.\" (stack2 skip inc)",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 6,
        realtime_duration_ms: 108617,
        realtime_start_ms: 652092,
        realtime_end_ms: 760709,
        realtime_shortest_duration_ms: 106813,
        name: "\"Follow me.\"",
        realtime_gold: false
      )
      run.segments << Segment.new(
          segment_number: 7,
        realtime_duration_ms: 75894,
        realtime_start_ms: 760709,
        realtime_end_ms: 836603,
        realtime_shortest_duration_ms: 72213,
        name: "End of cycle ride (bridge skip inc)",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 8,
        realtime_duration_ms: 395776,
        realtime_start_ms: 836603,
        realtime_end_ms: 1232379,
        realtime_shortest_duration_ms: 376917,
        name: "End of bridge thing",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 9,
        realtime_duration_ms: 18091,
        realtime_start_ms: 1232379,
        realtime_end_ms: 1250470,
        realtime_shortest_duration_ms: 16236,
        name: "Da Vinci",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 10,
        realtime_duration_ms: 394445,
        realtime_start_ms: 1250470,
        realtime_end_ms: 1644915,
        realtime_shortest_duration_ms: 394445,
        name: "\"Hey! Over here!\" #2",
        realtime_gold: true
      )
      run.segments << Segment.new(
        segment_number: 11,
        realtime_duration_ms: 329623,
        realtime_start_ms: 1644915,
        realtime_end_ms: 1974538,
        realtime_shortest_duration_ms: 329623,
        name: "Drive tank 4 feet",
        realtime_gold: true
      )
      run.segments << Segment.new(
        segment_number: 12,
        realtime_duration_ms: 273507,
        realtime_start_ms: 1974538,
        realtime_end_ms: 2248045,
        realtime_shortest_duration_ms: 158067,
        name: "Green guy",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 13,
        realtime_duration_ms: 158818,
        realtime_start_ms: 2248045,
        realtime_end_ms: 2406863,
        realtime_shortest_duration_ms: 155094,
        name: "Beat games",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 14,
        realtime_duration_ms: 114272,
        realtime_start_ms: 2406863,
          realtime_end_ms: 2521135,
        realtime_shortest_duration_ms: 109485,
        name: "Green guy talks to me",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 15,
        realtime_duration_ms: 414695,
        realtime_start_ms: 2521135,
        realtime_end_ms: 2935830,
        realtime_shortest_duration_ms: 127993,
        name: "Get across that bridge",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 16,
        realtime_duration_ms: 106491,
        realtime_start_ms: 2935830,
        realtime_end_ms: 3042321,
        realtime_shortest_duration_ms: 106491,
        name: "Jump up and down on three lightsabers",
        realtime_gold: true
      )
      run.segments << Segment.new(
        segment_number: 17,
        realtime_duration_ms: 43789,
        realtime_start_ms: 3042321,
        realtime_end_ms: 3086110,
        realtime_shortest_duration_ms: 36552,
        name: "\"That's Flynn's!\"",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 18,
        realtime_duration_ms: 66642,
        realtime_start_ms: 3086110,
        realtime_end_ms: 3152752,
        realtime_shortest_duration_ms: 65664,
        name: "Race green guy",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 19,
        realtime_duration_ms: 199229,
        realtime_start_ms: 3152752,
        realtime_end_ms: 3351981,
        realtime_shortest_duration_ms: 199228,
        name: "Kill green guy",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 20,
        realtime_duration_ms: 280615,
        realtime_start_ms: 3351981,
        realtime_end_ms: 3632596,
        realtime_shortest_duration_ms: 274927,
        name: "Jump the bike",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 21,
        realtime_duration_ms: 222151,
        realtime_start_ms: 3632596,
        realtime_end_ms: 3854747,
        realtime_shortest_duration_ms: 222151,
        name: "Grab me by the arm",
          realtime_gold: true
      )
      run.segments << Segment.new(
        segment_number: 22,
        realtime_duration_ms: 66152,
        realtime_start_ms: 3854747,
        realtime_end_ms: 3920899,
        realtime_shortest_duration_ms: 54341,
        name: "Popcorn ceiling's revenge",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 23,
        realtime_duration_ms: 98261,
        realtime_start_ms: 3920899,
        realtime_end_ms: 4019160,
        realtime_shortest_duration_ms: 79010,
        name: "Jump onto the flying staple",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 24,
        realtime_duration_ms: 397646,
        realtime_start_ms: 4019160,
        realtime_end_ms: 4416806,
        realtime_shortest_duration_ms: 368156,
        name: "Ride motorbike for 9 seconds",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 25,
        realtime_duration_ms: 0,
        realtime_start_ms: 0,
        realtime_end_ms: 0,
        realtime_shortest_duration_ms: 41308,
        name: "Final fight phase 1",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 26,
        realtime_duration_ms: 0,
        realtime_start_ms: 0,
        realtime_end_ms: 0,
        realtime_shortest_duration_ms: 161434,
        name: "Final fight phase 2",
        realtime_gold: false
      )
      run.segments << Segment.new(
        segment_number: 27,
        realtime_duration_ms: 247310,
        realtime_start_ms: 4416806,
        realtime_end_ms: 4664116,
        realtime_shortest_duration_ms: 27664,
        name: "Final fight phase 3",
        realtime_gold: false
      )

      run.histories << 
      run.histories << RunHistory.new(
        attempt_number: 1,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 2,
        realtime_duration_ms: 6911142,
        gametime_duration_ms: 6911142,
      )
      run.histories << RunHistory.new(
        attempt_number: 3,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 4,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 5,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 6,
        realtime_duration_ms: 6261793,
        gametime_duration_ms: 6261793,
      )
      run.histories << RunHistory.new(
        attempt_number: 7,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 8,
        realtime_duration_ms: 0,
          gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 9,
        realtime_duration_ms: 6123664,
        gametime_duration_ms: 6123664,
      )
      run.histories << RunHistory.new(
        attempt_number: 10,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 11,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 12,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 13,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 14,
        realtime_duration_ms: 5944515,
        gametime_duration_ms: 5944515,
      )
      run.histories << RunHistory.new(
        attempt_number: 15,
        realtime_duration_ms: 5694823,
        gametime_duration_ms: 5694823,
      )
      run.histories << RunHistory.new(
        attempt_number: 16,
        realtime_duration_ms: 5410111,
        gametime_duration_ms: 5410111,
      )
      run.histories << RunHistory.new(
        attempt_number: 17,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 18,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 19,
        realtime_duration_ms: 5746188,
        gametime_duration_ms: 5746188,
      )
      run.histories << RunHistory.new(
        attempt_number: 20,
        realtime_duration_ms: 5390459,
        gametime_duration_ms: 5390459,
      )
      run.histories << RunHistory.new(
        attempt_number: 21,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 22,
        realtime_duration_ms: 5258001,
        gametime_duration_ms: 5258001,
      )
      run.histories << RunHistory.new(
        attempt_number: 23,
        realtime_duration_ms: 5236112,
          gametime_duration_ms: 5236112,
      )
      run.histories << RunHistory.new(
        attempt_number: 24,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 25,
        realtime_duration_ms: 5102848,
        gametime_duration_ms: 5102848,
      )
      run.histories << RunHistory.new(
        attempt_number: 26,
        realtime_duration_ms: 5126404,
        gametime_duration_ms: 5126404,
      )
      run.histories << RunHistory.new(
        attempt_number: 27,
        realtime_duration_ms: 5055563,
        gametime_duration_ms: 5055563,
      )
      run.histories << RunHistory.new(
        attempt_number: 28,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 29,
        realtime_duration_ms: 6151829,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 30,
        realtime_duration_ms: 5407682,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 31,
        realtime_duration_ms: 5519460,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 32,
        realtime_duration_ms: 5290833,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 33,
        realtime_duration_ms: 5078376,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 34,
        realtime_duration_ms: 4816868,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 35,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 36,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 37,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 38,
        realtime_duration_ms: 5145497,
          gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 39,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 40,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 41,
        realtime_duration_ms: 4977554,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 42,
        realtime_duration_ms: 5025617,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 43,
        realtime_duration_ms: 4974734,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 44,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 45,
        realtime_duration_ms: 4868828,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 46,
        realtime_duration_ms: 5020524,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 47,
        realtime_duration_ms: 4664116,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 48,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 49,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 50,
        realtime_duration_ms: 4810072,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 51,
        realtime_duration_ms: 4681023,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 52,
        realtime_duration_ms: 0,
        gametime_duration_ms: 0,
      )
      run.histories << RunHistory.new(
        attempt_number: 53,
        realtime_duration_ms: 5048424,
        gametime_duration_ms: 0,
      )

      run
    end

    def self.example_segment
      segment = Segment.new(
        id: 'example'
      )

      segment.histories << SegmentHistory.new(
        attempt_number: 2,
        realtime_duration_ms: 72303
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 6,
        realtime_duration_ms: 73459
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 9,
        realtime_duration_ms: 69826
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 14,
        realtime_duration_ms: 82504
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 15,
        realtime_duration_ms: 70876
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 16,
        realtime_duration_ms: 69418
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 19,
        realtime_duration_ms: 69979
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 20,
        realtime_duration_ms: 73088
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 22,
        realtime_duration_ms: 68379
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 23,
        realtime_duration_ms: 70201
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 25,
        realtime_duration_ms: 67798
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 26,
        realtime_duration_ms: 67838
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 27,
        realtime_duration_ms: 67095
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 29,
        realtime_duration_ms: 72884
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 30,
        realtime_duration_ms: 68713
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 31,
        realtime_duration_ms: 99360
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 32,
        realtime_duration_ms: 68413
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 33,
        realtime_duration_ms: 69128
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 34,
        realtime_duration_ms: 67870
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 38,
        realtime_duration_ms: 0
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 41,
        realtime_duration_ms: 67306
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 42,
        realtime_duration_ms: 70221
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 43,
        realtime_duration_ms: 74078
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 45,
        realtime_duration_ms: 65664
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 46,
        realtime_duration_ms: 65998
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 47,
        realtime_duration_ms: 66641
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 50,
        realtime_duration_ms: 69105
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 51,
        realtime_duration_ms: 66313
      )
      segment.histories << SegmentHistory.new(
        attempt_number: 53,
        realtime_duration_ms: 74101
      )

      segment
    end
  end
end
