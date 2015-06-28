class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  has_one :user
  has_one :game
  has_one :category
  has_one :time

  attributes :id, :name, :program, :image_url, :created_at, :updated_at, :video_url

  private

  def id
    object.id36
  end
end
