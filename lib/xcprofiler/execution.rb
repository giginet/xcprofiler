require 'digest/md5'

module Xcprofiler
  class Execution
    Struct.new('Location', :path, :line, :column)

    attr_reader :time, :location, :method_name

    def initialize(time, location, method_name)
      @time = time.to_f
      unless location =~ /<invalid loc>/
        path, line, column = location.split(':')
        @location = Struct::Location.new(path, line.to_i, column.to_i)
      end
      @method_name = method_name
    end

    def to_h
      {
        method_name: method_name,
        time: time,
        path: path,
        line: line,
        column: column
      }
    end

    def invalid?
      !location
    end

    def path
      if @location
        @location.path
      else
        nil
      end
    end

    def filename
      if path
        File.basename(path)
      else
        nil
      end
    end

    def column
      if @location
        @location.column
      else
        nil
      end
    end

    def line
      if @location
        @location.line
      else
        nil
      end
    end
  end
end
