module Kindly
  module Handlers

    def self.register(name, converter)
      @@handlers ||= {}
      @@handlers[name.to_sym] = converter
    end

    def self.unregister(name)
      @@converters.delete(name.to_sym)
    end

    def self.find_by_name(name)
      @@converters[name.to_sym]
    end

    def self.find_by_ext(ext)
      # todo
      Default.new
    end

  end
end
