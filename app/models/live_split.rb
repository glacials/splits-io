require 'nokogiri'

module LiveSplit

  class Run < Run
    def self.sti_name
      :livesplit
    end

    def name
      read_attribute(:name) || parse && read_attribute(:name)
    end

    def read_from_file
      xml = Nokogiri::XML(run_file.file)

      update(
        program: :livesplit,
        name: "#{xml.at('Run > GameName').content} #{xml.at('Run > CategoryName').content}",
        category: Game.from_name(xml.at('Run > GameName').content).try do |game|
          game.categories.from_name(xml.at('Run > CategoryName').content)
        end
      )

      (xml.css('Run Segments Segment').count - splits.count).times { splits << splits.new }

      real_duration, game_duration = 0, 0

      xml.css('Run > Segments > Segment').map.with_index do |segment, index|
        splits[index].update(
          name: segment.at('Name').content,
          real_duration: real_duration += ChronicDuration.parse(
            segment.at('SplitTimes > SplitTime[name="Personal Best"] > RealTime').content
          ),
          game_duration: game_duration += ChronicDuration.parse(
            segment.at('SplitTimes > SplitTime[name="Personal Best"] > GameTime').content
          ),
          best_real_duration: segment.at('BestSegmentTime RealTime').content,
          best_game_duration: segment.at('BestSegmentTime GameTime').content
        )
      end
    end
  end

  class Split < Split
  end
end
