require 'json'

module Xcprofiler
  class JSONReporter < AbstractReporter
    def report!(executions)
      json = filter_executions(executions).map(&:to_h)
      unless output_path
        raise OutputPathIsNotSpecified, '[JSONReporter] output_path is not specified'
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
