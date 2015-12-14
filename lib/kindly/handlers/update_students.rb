require 'kindly'

module Kindly
  module Handlers
    class UpdateStudents

      def run(data)
        puts "The data is #{data}."
      end

    end

    register(:update_students, UpdateStudents.new)
  end
end
