require 'kindly'

module Kindly
  module Handlers
    class DoNothing

      def run(data)
        puts "Nothing happened."
      end

    end

    register(:do_nothing, DoNothing.new)
  end
end
