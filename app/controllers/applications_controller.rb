class ApplicationsController < ApplicationController
  before_action :set_application, only: [:destroy]
  def new
  end

  def create
    @application = Doorkeeper::Application.new(application_params[:doorkeeper_application])
    @application.owner = current_user if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      redirect_to settings_path, notice: 'Application created! :)'
    else
      error_text = @application.errors.full_messages.to_sentence
      redirect_to new_application_path, alert: ":( Failed to create application: #{error_text}."
    end
  end

  def destroy
    if cannot?(:destroy, @application)
      render :forbidden, status: 403
      return
    end

    @application.destroy
    redirect_to(settings_path, notice: "#{@application.name} deleted.")
  end

  private

  def set_application
    @application = Doorkeeper::Application.find(params[:application])
  end

  def application_params
    params.permit(doorkeeper_application: [:name, :redirect_uri])
  end
end
