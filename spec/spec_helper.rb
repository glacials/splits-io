require 'simplecov'
require 'json-schema-rspec'
SimpleCov.start do
  add_filter '/lib/parser/'
end

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.include JSON::SchemaMatchers
  # schema file
  config.json_schemas = {
    game: 'spec/support/views/api/v4/games/show.json',
    game_categories: 'spec/support/views/api/v4/games/categories/index.json',
    game_runners: 'spec/support/views/api/v4/games/runners/index.json',
    game_runs: 'spec/support/views/api/v4/games/runs/index.json',
    category: 'spec/support/views/api/v4/categories/show.json',
    category_runs: 'spec/support/views/api/v4/categories/runs/index.json',
    category_runners: 'spec/support/views/api/v4/categories/runners/index.json',
    runner_categories: 'spec/support/views/api/v4/runners/categories/index.json',
    runner_games: 'spec/support/views/api/v4/runners/games/index.json',
    runner_runs: 'spec/support/views/api/v4/runners/runs/index.json',
    runner_pbs: 'spec/support/views/api/v4/runners/pbs/index.json',
    run: 'spec/support/views/api/v4/runs/show.json',
    runner: 'spec/support/views/api/v4/runners/show.json'
  }
end
