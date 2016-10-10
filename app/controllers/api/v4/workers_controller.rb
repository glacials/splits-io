class Api::V4::WorkersController < Api::V4::ApplicationController
  before_action :set_run

  def create
    if @run.parse(fast: true, convert: false).blank?
      head 500
      return
    end

    head 202
  end
end
