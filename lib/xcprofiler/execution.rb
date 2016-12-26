module Xcprofiler
  class Execution
    Struct.new('Position', :path, :line, :column)

    attr_reader :time, :position, :method_name

    def initialize(time, position, method_name)
      @time = time.to_f
      unless position =~ /<invalid loc>/
        path, line, column = position.split(':')
        @position = Struct::Position.new(path, line.to_i, column.to_i)
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
      !position
    end

    def path
      if @position
        @position.path
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
      if @position
        @position.column
      else
        nil
      end
    end

    def line
      if @position
        @position.line
      else
        nil
      end
    end
  end
end
