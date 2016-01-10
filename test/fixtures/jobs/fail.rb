require 'kindly'

module Fixtures
  module Jobs
    class Fail

      def run
        raise "This handler fails every time."
      end

    end

    Kindly::Registry.register(:fail, Fail.new)
  end
end
