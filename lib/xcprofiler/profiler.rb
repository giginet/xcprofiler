require 'terminal-table'
require 'colorize'

module Xcprofiler
  class Profiler
    attr_writer :reporters
    attr_reader :derived_data

    def self.by_path(activity_log_path)
      derived_data = DerivedData.new(activity_log_path)
      Profiler.new(derived_data)
    end

    def self.by_product_name(product_name)
      derived_data = DerivedData.by_product_name(product_name)
      Profiler.new(derived_data)
    end

    def initialize(derived_data)
      @derived_data = derived_data
    end

    def report!
      if !derived_data.flag_enabled?
        raise BuildFlagIsNotEnabled, "'-Xfrontend -debug-time-function-bodies' flag is not enabled"
      end

      reporters.each do |reporter|
        filtered = reporter.filter_executions(derived_data.executions)
        reporter.report!(filtered)
      end
    end

    private

    def reporters
      @reporters ||= [StandardOutputReporter.new(limit: options[:limit], order: options[:order])]
    end
  end
end
