class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  has_one :user, serializer: class.parent::UserSerializer
  has_one :game, serializer: class.parent::GameSerializer
  has_one :category, serializer: class.parent::CategorySerializer
  has_one :time

  attributes :id, :name, :program, :image_url, :created_at, :updated_at

  def id
    object.id36
  end

  def time
    OpenStruct.new(serializable_hash: object.time.to_f)
  end
end
