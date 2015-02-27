require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Migration

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def move(destination)
      dir = Kindly.config[destination]
      FileUtils.mkdir(dir) unless Dir.exist?(dir)
      FileUtils.mv(@filename, dir)
      @filename = File.join(dir, File.basename(@filename))
    end

    def running!
      move(:running)
      puts "#{@filename} running."
    end

    def completed!
      move(:completed)
      puts "#{@filename} completed."
    end

    def failed!
      move(:failed)
      puts "#{@filename} failed."
    end

  end
end
