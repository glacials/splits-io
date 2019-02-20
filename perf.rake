require 'bundler'
Bundler.setup

require 'derailed_benchmarks'
require 'derailed_benchmarks/tasks'

class AuthieAuth < DerailedBenchmarks::AuthHelper
  def setup
    require 'authie/rack_controller'
    @user = User.first
  end

  def call(env)
    controller = Authie::RackController.new(env)
    controller.current_user = @user
    app.call(env)
  end
end

DerailedBenchmarks.auth = AuthieAuth.new
