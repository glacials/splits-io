class Api::V4::RunWithHistorySerializer < Api::V4::RunSerializer
  attributes :history

  def history
    object.histories
  end
end
