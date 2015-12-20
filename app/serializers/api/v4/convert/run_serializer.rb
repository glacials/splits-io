class Api::V4::Convert::RunSerializer < Api::V4::ApplicationSerializer
  attributes :id, :srdc_id, :name, :time, :program, :image_url, :video_url, :created_at, :updated_at, :splits

  def created_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def updated_at
    DateTime.now.utc.to_s(:iso8601)
  end

  def history
    object.history || []
  end
end
