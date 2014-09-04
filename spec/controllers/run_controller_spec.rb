require 'spec_helper'

describe RunsController do
  it 'should set runs properly' do
    get 'run_show', run: Run.create!.id.to_s(36)
    response.should be_success
  end

end
