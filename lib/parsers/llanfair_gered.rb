require 'nokogiri'

module LlanfairGered
  def self.to_s
    "Llanfair (Gered's fork)"
  end

  def self.to_sym
    :llanfair_gered
  end

  def self.file_extension
    'lfs'
  end

  def self.website
    'https://github.com/gered/Llanfair'
  end

  class Parser
    def parse(xml, fast: true)
      xml = Nokogiri::XML(xml)

      # Prevent LiveSplit or other XML-based runs from tricking us
      if xml.at('Run > Run > default').nil?
        return nil
      end

      run = {
        game: nil,
        category: nil,
        attempts: xml.at('Run > Run > default > numberOfAttempts'),
        splits: [],
        history: [],
        indexed_history: {}
      }

      xml.search('Run > Run > default > segments > Segment').each do |xml_segment|
        segment = Split.new

        if run[:splits].empty?
          segment.start_time = 0
        else
          segment.start_time = run[:splits].last.finish_time
        end

        segment.name = xml_segment.at('Segment > default > name').content
        segment.best = seconds(xml_segment.at('Segment > default > bestTime > milliseconds').content)

        duration = nil

        ref = xml_segment.at('Segment > default > runTime').attributes['reference']
        if !ref.nil? && ref.value == '../bestTime'
          duration = xml_segment.at('Segment > default > bestTime > milliseconds').content
        else
          duration = xml_segment.at('Segment > default > runTime > milliseconds').content
        end
        segment.duration = seconds(duration)

        segment.finish_time = segment.start_time + segment.duration

        run[:splits] << segment
      end

      return run
    rescue
      nil
    end

    private

    def seconds(xml_tag_content)
      (xml_tag_content.to_i / 1000.0)
    end
  end
end
