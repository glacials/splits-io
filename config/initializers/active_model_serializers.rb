module ActiveModel::Serializer::EnableRootNodesGlobally
  def initialize(serializer, options = {})
    super(serializer, options)
    serializer.root = true
  end
end

class ActiveModel::Serializer::Adapter::Json
  prepend ActiveModel::Serializer::EnableRootNodesGlobally
end
