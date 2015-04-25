class Api::V4::ApplicationSerializer < ActiveModel::Serializer
  delegate :cache_key, to: :object
end
