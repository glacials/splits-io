require 'rails_helper'

describe SegmentGroup, type: :model do
  context 'subsplits with titles' do
    let(:segments) do
      run = FactoryBot.create :run
      segments = []
      segments << FactoryBot.create(:segment, run: run, segment_number: 1, name: '-Split 1')
      segments << FactoryBot.create(:segment, run: run, segment_number: 2, name: '-Split 2')
      segments << FactoryBot.create(:segment, run: run, segment_number: 3, name: '-Split 3')
      segments << FactoryBot.create(:segment, run: run, segment_number: 4, name: '-Split 4')
      segments << FactoryBot.create(:segment, run: run, segment_number: 5, name: '{Splits} Split 5')
      segments
    end

    it 'understands how to determine if a segment is a subsplit' do
      segment_group = SegmentGroup.new(segments)
      expect(segment_group.segments[0].subsplit?).to be true
      expect(segment_group.segments[0].last_subsplit?).to be false
      expect(segment_group.segments[4].last_subsplit?).to be true
    end

    it 'generates the correct display_name' do
      segment_group = SegmentGroup.new(segments)
      expect(segment_group.display_name).to eq('Splits')
    end
  end

  context 'subsplits without titles' do
    let(:segments) do
      run = FactoryBot.create :run
      segments = []
      segments << FactoryBot.create(:segment, run: run, segment_number: 1, name: '-Split 1')
      segments << FactoryBot.create(:segment, run: run, segment_number: 2, name: '-Split 2')
      segments << FactoryBot.create(:segment, run: run, segment_number: 3, name: '-Split 3')
      segments << FactoryBot.create(:segment, run: run, segment_number: 4, name: '-Split 4')
      segments << FactoryBot.create(:segment, run: run, segment_number: 5, name: 'Split 5')
      segments
    end

    it 'understands how to determine if a segment is a subsplit' do
      segment_group = SegmentGroup.new(segments)
      expect(segment_group.segments[0].subsplit?).to be true
      expect(segment_group.segments[0].last_subsplit?).to be false
      expect(segment_group.segments[4].last_subsplit?).to be true
    end

    it 'generates the correct display_name' do
      segment_group = SegmentGroup.new(segments)
      expect(segment_group.display_name).to eq('Split 5')
    end
  end
end
