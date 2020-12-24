class Api::V4::FeedItemBlueprint < Blueprinter::Base
  fields :type

  association :run, blueprint: Api::V4::RunBlueprint
end
