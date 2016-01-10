require 'kindly'

module Kindly
  module Jobs
    class TestJobWithInput

      attr_accessor :input

      def run
        puts "input: #{@input}"
      end

    end

    Kindly::Registry.register(:test_job_with_input, TestJobWithInput.new)
  end
end
