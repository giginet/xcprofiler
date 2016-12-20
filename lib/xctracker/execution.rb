module Xctracker
  class Execution
    Struct.new('Position', :filepath, :lineno, :column)

    def initialize(time, position, method_name)
      @time = time.to_f
      unless position =~ /<invalid loc>/
        filepath, lineno, column = position.split(':')
        if File.exist?(filepath)
          @position = Struct::Position.new(filepath, lineno, column)
        end
      end
      @method_name = method_name
    end
  end
end
