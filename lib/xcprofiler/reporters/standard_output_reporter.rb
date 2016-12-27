require 'terminal-table'

module Xcprofiler
  class StandardOutputReporter < AbstractReporter
    def report!(executions)
      filtered = filter_executions(executions)
      puts table_for(filtered)
    end

    def table_for(executions)
      Terminal::Table.new do |t|
        t << ['File', 'Line', 'Method name', 'Time(ms)']
        t << :separator
        executions.each do |execution|
          t << [execution.filename, execution.line, execution.method_name, execution.time]
        end
      end
    end
  end
end
