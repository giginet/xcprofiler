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

      reporters.each do |reporter|
        reporter = reporter
        reporter.report!(latest_data.executions)
      end
    end

    private

    def reporters
      @reporters ||= [StandardOutputReporter.new(limit: options[:limit], order: options[:order])]
    end

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

    def derived_data_root
      File.expand_path('~/Library/Developer/Xcode/DerivedData')
    end
  end
end
