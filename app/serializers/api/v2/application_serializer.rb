class Api::V2::ApplicationSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object
end
