module Xctracker
  class Execution
    Struct.new('Position', :path, :line, :column)

    attr_reader :time, :position, :method_name

    def initialize(time, position, method_name)
      @time = time.to_f
      unless position =~ /<invalid loc>/
        path, line, column = position.split(':')
        if File.exist?(path)
          @position = Struct::Position.new(path, line.to_i, column.to_i)
        end
      end
      @method_name = method_name
    end

    def to_h
      {
        method_name: execution.method_name,
        time: execution.time,
        path: execution.path,
        line: execution.line,
        column: execution.column
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
