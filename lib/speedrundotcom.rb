module SpeedrunDotCom
  module Run
    def self.id_from_url(url)
      if url.blank?
        return nil
      end

      URI.parse(url).tap do |uri|
        unless uri.host =~ /^(www\.)?(speedrun.com)$/ && uri.path =~ /^\/run\/(.*)$/
          return false
        end

        return /^\/run\/(.*)$/.match(uri.path)[1]
      end
    rescue URI::InvalidURIError
      return false
    end

    def self.url_from_id(id)
      return nil if id.blank?
      "http://www.speedrun.com/run/#{id}"
    end
  end
end
