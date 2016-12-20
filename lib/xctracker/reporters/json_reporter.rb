require 'xctracker/reporters/abstract_reporter'
require 'json'

module Xctracker
  class JSONReporter < AbstractReporter
    def report!(executions)
      json = filter_executions(executions).map(&:to_h)
      File.open(output_file, "w") do |f|
        f.write(JSON.pretty_print(json))
      end
    end

    private

    def output_file
      options[:output_file]
    end
  end
end
