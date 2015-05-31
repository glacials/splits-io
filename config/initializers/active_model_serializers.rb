class ActiveModel::Serializer::Adapter::Json
  def initialize_with_root(serializer, options = {})
    initialize_without_root(serializer, options)
    serializer.root = true
  end
  alias_method_chain :initialize, :root
end
