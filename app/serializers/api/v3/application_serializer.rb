class Api::V3::ApplicationSerializer < ActiveModel::Serializer
  delegate :cache_key, to: :object
end
