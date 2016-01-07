require 'kindly'

module Kindly
  module Handlers
    class UpdateStudent

      def run(data)
        puts "The data is #{data}."
      end

    end

    register(:update_student, UpdateStudent.new)
  end
end
