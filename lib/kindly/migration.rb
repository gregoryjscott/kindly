require 'kindly'
require 'fileutils'
require 'json'

module Kindly
  class Migration

    attr_reader :filename

    def self.source
      ''
    end

    def self.find_pending
      migrations = []
      filenames =  Dir[File.join(source, 'pending', '*.json')]
      filenames.each do |filename|
        migrations << Migration.new(filename)
      end
      migrations
    end

    def initialize(filename)
      @filename = filename
    end

    def load
      puts "#{@filename} loading."
      File.open(@filename) { |file| JSON.load(file) }
    end

    def move(destination)
      path = File.join(self.class.source, destination)
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
