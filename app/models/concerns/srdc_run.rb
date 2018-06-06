require 'active_support/concern'

require 'speedrundotcom'

module SRDCRun
  extend ActiveSupport::Concern

  class_methods do
    def set_runner_from_srdc(run_id, srdc_run_id)
      run = Run.find(run_id)
      return if srdc_run_id.nil? || run.user.present?

      srdc_runner_id = SpeedrunDotCom::Run.runner_id(srdc_run_id)
      return if srdc_runner_id.nil?
      twitch_login = SpeedrunDotCom::User.twitch_login(srdc_runner_id)
      return if twitch_login.blank?

      run.update(user: User.find_by(name: twitch_login))
    end
  end

  included do
    def srdc_url
      SpeedrunDotCom::Run.url_from_id(srdc_id) if srdc_id.present?
    end

    def srdc_url=(url)
      srdc_id = SpeedrunDotCom::Run.id_from_url(url)
    end
  end
end
