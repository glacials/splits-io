require 'rails_helper'

RSpec.describe 'users/pbs/export/panels/index' do
  it 'renders the index template' do
    run = FactoryGirl.create(:run)

    runs = double
    allow(runs).to receive(:order).and_return(runs)
    allow(runs).to receive(:where).and_return(runs)
    allow(runs).to receive(:not).and_return(runs)
    allow(runs).to receive(:count).and_return(1)
    allow(runs).to receive(:map).and_yield(run).and_return([4])
    allow(runs).to receive(:each).and_yield(run)

    assign(:runs, runs)

    render

    expect(view).to render_template('users/pbs/export/panels/index')
  end
end
