require 'spec_helper'

describe Run do
  it 'should generate 4-character nicks' do
    run = Run.create!
    run.nick.length.should eq(4)
  end

end
