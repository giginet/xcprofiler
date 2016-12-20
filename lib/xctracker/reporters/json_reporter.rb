require 'xctracker/reporters/abstract_reporter'
require 'json'

module Xctracker
  class JSONReporter < AbstractReporter
    def report!(executions)
      json = filter_executions(executions).map(&:to_h)
      unless output_path
        raise '[JSONReporter] output_path is not specified'.red
      end

      File.open(output_path, "w") do |f|
        f.write(JSON.pretty_generate(json))
      end
    end

    private

    def output_path
      options[:output_path]
    end
  end
end
