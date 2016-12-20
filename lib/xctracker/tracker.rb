require 'terminal-table'
require 'colorize'

module Xctracker
  class Tracker
    attr_reader :product_name, :options

    def initialize(product_name, options)
      @product_name = product_name
      @options = options
    end

    def report!
      latest_data = latest_derived_data(product_name)

      executions = latest_data.sorted_executions(order)
      executions = executions.delete_if(&:invalid?) unless verbose?
      executions = executions[0...limit] if limit

      f = formatter(executions)
      puts f.table
    end

    private

    def latest_derived_data(product_name)
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

      latest_data
    end

    def limit
      options[:limit]
    end

    def verbose?
      options[:verbose]
    end

    def order
      options[:order]
    end

    def formatter(executions)
      Formatter.new(executions)
    end

    def derived_data_root
      File.expand_path('~/Library/Developer/Xcode/DerivedData')
    end
  end
end
