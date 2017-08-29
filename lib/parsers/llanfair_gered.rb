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

  def self.content_type
    'application/llanfair-gered'
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
          segment.realtime_start = 0
        else
          segment.realtime_start = run[:splits].last.realtime_end
        end

        segment.name = xml_segment.at('Segment > default > name').content
        segment.realtime_best = seconds(xml_segment.at('Segment > default > bestTime > milliseconds').content)

        duration = nil

        ref = xml_segment.at('Segment > default > runTime').attributes['reference']
        if !ref.nil? && ref.value == '../bestTime'
          duration = xml_segment.at('Segment > default > bestTime > milliseconds').content
        else
          duration = xml_segment.at('Segment > default > runTime > milliseconds').content
        end

        segment.realtime_duration = seconds(duration)
        segment.realtime_end = segment.realtime_start + segment.realtime_duration

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
