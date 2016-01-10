require 'kindly'

module Kindly
  module Jobs
    class DoNothing

      def run
        puts "Nothing happened."
      end

    end

    Kindly::Registry.register(:do_nothing, DoNothing.new)
  end
end
