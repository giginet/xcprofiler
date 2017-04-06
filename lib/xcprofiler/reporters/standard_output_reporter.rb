require 'terminal-table'

module Xcprofiler
  class StandardOutputReporter < AbstractReporter
    def report!(executions)
      puts table_for(executions)
    end

    private

    def table_for(executions)
      Terminal::Table.new do |t|
        t << ['File', 'Line', 'Method name', 'Time(ms)']
        t << :separator
        executions.each do |execution|
          t << [execution.filename, execution.line, truncate(execution.method_name), execution.time]
        end
      end
    end
  end
end
