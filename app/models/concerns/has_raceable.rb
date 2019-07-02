require 'active_support/concern'

module HasRaceable
  extend ActiveSupport::Concern

  included do
    # Retrive all raceables (races, bingos, randomizers) for the given game
    #
    # @param scope [Symbol, Array<Symbol>] any scope(s) to apply to each raceable class
    # @param paginate [Nil, Integer] Page to paginate raceables on, nil for no pagination
    #
    # @return [Array] All raceables in one array
    def raceables(scope = nil, paginate = nil)
      [races, randomizers, bingos].map do |r|
        r.limit(100)
        r.page(paginate) if paginate.present?
        next r.to_a if scope.nil?

        scope = [scope] unless scope.respond_to?(:each)
        scope.inject(r, :send)
      end.flatten.sort_by(&:created_at).reverse
    end
  end
end
