class Runs::ApplicationController < ApplicationController
  private

  def set_run
    @run = Run.includes(:user, :game, :category, :segments).find_by!(id: params[:run].to_i(36))
    timing = params[:timing] || @run.default_timing
    gon.run = {id: @run.id36, splits: @run.collapsed_segments(timing)}
    gon.scale_to = @run.duration_ms(timing)

    if params[:blank] == '1' # Build a fake, non-persisted run
      set_blank_run
      return
    end
  rescue ActionController::UnknownFormat, ActiveRecord::RecordNotFound
    not_found
  end

  def set_blank_run
    fake_run = Run.new(category: @run.category, program: Programs::ExchangeFormat.to_sym)

    # We can't use find_each here since it doesn't respect order. We need the order to be applied correctly on append,
    # because we're not persisting this run to the database so we can't sort it on "select". We have to keep all
    # segments in memory on the fake run anyway, so 2x that should be fine.
    @run.segments.order(segment_number: :asc).each do |segment|
      fake_run.segments << Segment.new(segment_number: segment.segment_number, name: segment.name)
    end

    @run = fake_run
  end
end
