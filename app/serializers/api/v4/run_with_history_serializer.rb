class Api::V4::RunWithHistorySerializer < Api::V4::RunSerializer
  attributes :history

  private

  def history
    object.history || []
  end
end
