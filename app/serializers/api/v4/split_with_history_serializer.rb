class Api::V4::SplitWithHistorySerializer < Api::V4::SplitSerializer
  attributes :history

  private

  def history
    object.history || []
  end
end
