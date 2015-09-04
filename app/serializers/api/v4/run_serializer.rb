class Api::V4::RunSerializer < Api::V4::ApplicationSerializer
  has_one :game
  has_one :category

  attributes :id, :srdc_id, :name, :time, :program, :attempts, :image_url, :created_at, :updated_at, :video_url

  private

  def id
    object.id36
  end

  def runner
    object.user
  end
end
