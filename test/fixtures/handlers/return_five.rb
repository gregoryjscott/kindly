require 'kindly'

module Fixtures
  module Handlers
    class ReturnFive

      def run(data)
        5
      end

    end

    Kindly::Handlers.register(:return_five, ReturnFive.new)
  end
end
