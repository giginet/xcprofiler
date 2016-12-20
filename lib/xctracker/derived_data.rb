require 'zlib'

module Xctracker
  class DerivedData
    def initialize(path)
      @path = path
    end

    def updated_at
      File.mtime(@path)
    end

    def parse_executions
      lines.map { |line|
        if line =~ /^\d*\.?\dms\t/
          time, file, method_name = line.split(/\t/)
          Execution.new(time, file, method_name)
        end
      }.compact
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
