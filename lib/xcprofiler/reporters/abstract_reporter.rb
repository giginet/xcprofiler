module Xcprofiler
  class AbstractReporter
    attr_reader :options

    DEFAULT_TRUNCATE_LIMIT = 150

    def initialize(options = {})
      @options = options
    end

    def report!(executions)
      raise NotImplementedError, 'Not implemented'
    end

    def filter_executions(executions)
      executions = sort_executions(executions, order)
      executions = executions.delete_if(&:invalid?) unless show_invalid_locations?
      executions = executions.delete_if { |v| v.time < threshold } if threshold
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

    def truncate_limit
      options[:truncate_limit] ||= DEFAULT_TRUNCATE_LIMIT
    end

    def truncate(text)
      return text unless text.length >= truncate_limit

      omission = '...'
      length_with_room_for_omission = truncate_limit - omission.length
      "#{text[0...length_with_room_for_omission]}#{omission}"
    end
  end
end
