module Admin
  class GamesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Game.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    def find_resource(param)
      Game.joins(:srdc).find_by(srdc: {shortname: param}) || Game.find_by!(id: param)
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
