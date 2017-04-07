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
          t << [execution.filename, execution.line, truncate(execution.method_name, truncate_at), execution.time]
        end
      end
    end

    def truncate(text, truncate_at)
      omission = '...'
      return text unless text.length >= truncate_at
      return text unless truncate_at >= omission.length
      length_with_room_for_omission = truncate_at - omission.length
      "#{text[0...length_with_room_for_omission]}#{omission}"
    end
  end
end
