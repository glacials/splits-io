class Runs::ApplicationController < ApplicationController
  private

  def set_run
    @run = Run.includes(:user, :game, :category, :segments).find_by(id: params[:run].to_i(36)) || Run.find_by!(nick: params[:run])
    timing = params[:timing] || @run.default_timing
    gon.run = {id: @run.id36, splits: @run.collapsed_segments(timing)}
    gon.scale_to = @run.duration_ms(timing)

    if params[:blank] == '1' # Build a fake, non-persisted run
      fake_run = Run.new(category: @run.category, program: ExchangeFormat.to_sym)
      @run.segments.find_each do |segment|
        fake_run.segments << Segment.new(segment_number: segment.segment_number, name: segment.name)
      end

      @run = fake_run
      return
    end
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    not_found
  end
end
