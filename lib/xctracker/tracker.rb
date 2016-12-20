require 'terminal-table'
require 'colorize'

module Xctracker
  class Tracker
    class << self
      def report(product_name, options)
        pattern = File.join(derived_data_root, "#{product_name}-*", "Logs", "Build", "*.xcactivitylog")
        derived_data = Dir.glob(pattern).map { |path|
          DerivedData.new(path)
        }

        if derived_data.empty?
          raise "Build log for #{product_name} is not found".red
        end

        latest_data = derived_data.max { |data| data.updated_at }
        if !latest_data.flag_enabled?
          raise "Not enabled '-Xfrontend -debug-time-function-bodies' in this project".red
        end

        f = formatter(latest_data.executions)
        puts f.table
      end

      private

      def formatter(executions)
        Formatter.new(executions)
      end

      def derived_data_root
        File.expand_path('~/Library/Developer/Xcode/DerivedData')
      end
    end
  end
end
