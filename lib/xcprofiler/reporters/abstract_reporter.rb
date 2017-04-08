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
      executions = sort_executions(executions, order)
      executions = executions.delete_if(&:invalid?) unless show_invalid_locations?
      executions = delete_duplicated(executions) unless allow_duplicated
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

    def delete_duplicated(executions)
      already_in_set_ids = []
      filtered = []
      time_records = get_time_records(executions)

      executions.each do |e|
        next if already_in_set_ids.include?(e.record_id)
        next if time_records[e.record_id] > e.time
        already_in_set_ids << e.record_id
        filtered << e
      end
      filtered
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

    def allow_duplicated
      options[:allow_duplicated]
    end

    private

    def get_time_records(executions)
      memo = {}
      executions.each do |e|
        next if memo.has_key?(e.record_id) && memo[e.record_id] > e.time
        memo[e.record_id] = e.time
      end
      memo
    end
  end
end
