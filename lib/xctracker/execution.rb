module Xctracker
  class Execution
    Struct.new('Position', :filepath, :line, :column)

    attr_reader :time, :position, :method_name

    def initialize(time, position, method_name)
      @time = time.to_f
      unless position =~ /<invalid loc>/
        filepath, line, column = position.split(':')
        if File.exist?(filepath)
          @position = Struct::Position.new(filepath, line, column)
        end
      end
      @method_name = method_name
    end

    def invalid?
      !position
    end

    def filename
      if @position
        File.basename(@position.filepath)
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
