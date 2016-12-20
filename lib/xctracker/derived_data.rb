require 'zlib'

module Xctracker
  class DerivedData
    def initialize(path)
      @path = path
    end

    def updated_at
      File.mtime(@path)
    end

    def executions
      @executions ||= lines.map { |line|
        if line =~ /^\d*\.?\dms\t/
          time, file, method_name = line.split(/\t/)
          Execution.new(time, file, method_name)
        end
      }.compact
    end

    def sorted_executions(order)
      case order
        when :default
          executions
        when :time
          executions.sort { |a, b| [b.time, a.filename, a.line] <=> [a.time, b.filename, b.line] }
        when :file
          executions.sort_by { |e| [e.filename, e.line] }
      end
    end

    def flag_enabled?
      lines.any? { |l| l.include?('-Xfrontend -debug-time-function-bodies') }
    end

    private

    def lines
      unless @lines
        Zlib::GzipReader.open(@path) do |gz|
          @lines = gz.read.split(/\r/)
        end
      end
      @lines
    end
  end
end
