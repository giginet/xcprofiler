module Xctracker
  class Formatter
    def initialize(executions, options = {})
      options[:limit] ||= 100
      @limit = options[:limit]

      @executions = executions
    end

    def table
      Terminal::Table.new do |t|
        t << ['File', 'Line', 'Method name', 'Time(ms)']
        t << :separator
        executions.each do |execution|
          t << [execution.filename, execution.line, execution.method_name, execution.time]
        end
      end
    end

    private

    def executions
      @executions ||= []
      @executions = @executions.delete_if(&:invalid?)
      @executions[0...@limit].sort { |a, b| b.time <=> a.time }
    end
  end
end
