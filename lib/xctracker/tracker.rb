require 'terminal-table'

module Xctracker
  class Tracker
    class << self
      def report(product_name, options)
        pattern = File.join(derived_data_root, "#{product_name}-*", "Logs", "Build", "*.xcactivitylog")
        derived_data = Dir.glob(pattern).map { |path|
          DerivedData.new(path)
        }
        puts table(derived_data.first.parse_executions)
      end

      private

      def table(executions)
        Terminal::Table.new do |t|
          t << ['File', 'Line', 'Method name', 'Time(ms)']
          t << :separator
          executions.each do |execution|
            t << [execution.filename, execution.line, execution.method_name, execution.time]
          end
        end
      end

      def derived_data_root
        File.expand_path('~/Library/Developer/Xcode/DerivedData')
      end
    end
  end
end
