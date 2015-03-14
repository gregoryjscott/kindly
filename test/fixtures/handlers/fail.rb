require 'kindly'

module Fixtures
  module Handlers
    class Fail

      def glob
        '*'
      end

      def run(migration)
        raise "This handler fails every time."
      end

    end

    Kindly::Handlers.register(:fail, Fail.new)
  end
end
