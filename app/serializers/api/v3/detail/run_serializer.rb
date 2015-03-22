class Api::V3::Detail::RunSerializer < Api::V3::ApplicationSerializer
  has_one :user, serializer: Api::V3::UserSerializer
  has_one :game, serializer: Api::V3::GameSerializer
  has_one :category, serializer: Api::V3::CategorySerializer
  has_one :time
  has_many :splits

  attributes :id, :path, :name, :program, :image_url, :created_at, :updated_at

  def time
    OpenStruct.new(serializable_hash: object.time.to_f)
  end
end
