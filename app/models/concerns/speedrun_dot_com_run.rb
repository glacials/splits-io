require 'active_support/concern'

module SpeedrunDotComRun
  extend ActiveSupport::Concern

  included do
    def srdc_url
      SpeedrunDotCom::Run.url_from_id(srdc_id) if srdc_id.present?
    end

    def srdc_url=(url)
      srdc_id = SpeedrunDotCom::Run.id_from_url(url)
    end
  end
end
