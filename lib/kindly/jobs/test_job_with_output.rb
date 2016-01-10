require 'kindly'

module Kindly
  module Jobs
    class TestJobWithOutput

      attr_accessor :output

      def run
        @output = 'goodbye'
      end

    end

    Kindly::Registry.register(:test_job_with_output, TestJobWithOutput.new)
  end
end
