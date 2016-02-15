require 'active_support/concern'

require 'speedrundotcom'

module SRDCRun
  extend ActiveSupport::Concern

  included do
    def srdc_url
      SpeedrunDotCom::Run.url_from_id(srdc_id) if srdc_id.present?
    end

    def srdc_url=(url)
      srdc_id = SpeedrunDotCom::Run.id_from_url(url)
    end

    def set_runner_from_srdc
      return if srdc_id.nil? || user.present?

      srdc_run = SpeedrunDotCom.run(srdc_id)
      return if srdc_run.blank?

      srdc_runner = SpeedrunDotCom.user(srdc_run.players[0]['id'])
      return if srdc_runner.blank?

      update(user: User.find_by(srdc_runner.twitch_login))
    rescue SpeedrunDotCom::RunNotFound, SpeedrunDotCom::UserNotFound, SpeedrunDotCom::
    end
  end
end
