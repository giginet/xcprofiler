module Xctracker
  class AbstractReporter
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def report!(executions)
      raise NotImplementedError, 'Not implemented'
    end

    protected

    def filter_executions(executions)
      executions = sort_executions(executions, order)
      executions = executions.delete_if(&:invalid?) unless show_invalid_locations?
      executions = executions[0...limit] if limit
      executions
    end

    def sort_executions(executions, order)
      case order
        when :default
          executions
        when :time
          executions.sort { |a, b| [b.time, (a.filename or ''), (a.line or 0)] <=> [a.time, (b.filename or ''), (b.line or 0)] }
        when :file
          executions.sort { |a, b| [(a.filename or ''), (a.line or 0)] <=> [(b.filename or ''), (b.line or 0)] }
      end
    end

    def limit
      options[:limit]
    end

    def show_invalid_locations?
      options[:show_invalid_locations] || false
    end

    def order
      options[:order] || :time
    end
  end
end
