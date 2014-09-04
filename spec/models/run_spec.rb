require 'spec_helper'

describe Run do
  it 'should respond to base 36 ids' do
    run = nil
    10.times { run = Run.create! }
    expect(Run.find('a'.to_i 36)).to eq(run)
  end

  it 'should be deleted properly' do
    run = Run.create!
    id = run.id
    run.destroy
    expect(Run.find_by_id id).to be nil
  end
end
