require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Migration

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def load
      puts "#{@filename} loading."
      File.open(@filename) { |file| JSON.load(file) }
    end

    def move(destination)
      path = File.join(Kindly.source, destination)
      FileUtils.mkdir(path) unless Dir.exist?(path)
      FileUtils.mv(@filename, path)
      @filename = File.join(path, File.basename(@filename))
    end

    def running!
      move('running')
      puts "#{@filename} running."
    end

    def completed!
      move('completed')
      puts "#{@filename} completed."
    end

    def failed!
      move('failed')
      puts "#{@filename} failed."
    end

  end
end
