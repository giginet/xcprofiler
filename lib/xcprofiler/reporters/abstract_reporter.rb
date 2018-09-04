module Xcprofiler
  class AbstractReporter
    attr_reader :options

    DEFAULT_TRUNCATE_AT = 150

    def initialize(options = {})
      @options = options
    end

    def report!(executions)
      raise NotImplementedError, 'Not implemented'
    end

    def filter_executions(executions)
      executions = executions.delete_if(&:invalid?) unless show_invalid_locations?
      executions = delete_duplicated(executions) if unique
      executions = group_by_executions_per_file(executions) if per_file
      executions = executions.delete_if { |v| v.time < threshold } if threshold
      executions = sort_executions(executions, order)
      executions = executions[0...limit] if limit
      executions
    end

    protected

    def sort_executions(executions, order)
      case order
        when :default
          executions
        when :time
          executions.sort { |a, b| [b.time, (a.filename or ''), (a.line or 0)] <=> [a.time, (b.filename or ''), (b.line or 0)] }
        when :file
          executions.sort { |a, b| [(a.filename or ''), (a.line or 0), b.time] <=> [(b.filename or ''), (b.line or 0), a.time] }
      end
    end

    def delete_duplicated(executions)
      executions.group_by { |execution| 
        execution.location 
      }.map { |location, executions| 
        executions.max { |execution| execution.time }
      }
    end

    def group_by_executions_per_file(executions)
      executions.group_by { |execution|
        execution.path
      }.map { |path, executions|
        time = executions.map(&:time).reduce(:+)
        Execution.new(time, "#{path}:0:0", '')
      }
    end

    def limit
      options[:limit]
    end

    def threshold
      options[:threshold]
    end

    def show_invalid_locations?
      options[:show_invalid_locations] || false
    end

    def order
      options[:order] || :time
    end

    def truncate_at
      options[:truncate_at] ||= DEFAULT_TRUNCATE_AT
    end

    def unique
      return options[:unique] unless options[:unique].nil?
      true
    end

    def per_file
      options[:per_file] || false
    end
  end
end
