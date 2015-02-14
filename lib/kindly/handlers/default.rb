require 'kindly'

module Kindly
  module Handlers
    class Default

      def ext
        '*'
      end

      def run(migration)
        puts "The default handler for #{migration.filename} does nothing."
      end

    end

    register(:default, Default.new)
  end
end
