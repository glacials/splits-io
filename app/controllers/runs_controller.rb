class RunsController < ApplicationController
  def upload
  end
  def upload_post
    uploaded_io = params[:data]
    redirect_to root_path, notice: "Test notice."
  end
  def popular
  end
end
