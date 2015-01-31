class Api::V3::ApplicationSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object
end
