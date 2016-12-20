require 'zlib'

module Xctracker
  class DerivedData
    class << self
      def all
        pattern = File.join(derived_data_root, "**", "Logs", "Build", "*.xcactivitylog")
        by_pattern(pattern)
      end

      def by_product_name(product_name)
        pattern = File.join(derived_data_root, "#{product_name}-*", "Logs", "Build", "*.xcactivitylog")
        by_pattern(pattern)
      end

      private

      def by_pattern(pattern)
        derived_data = Dir.glob(pattern).map { |path|
          DerivedData.new(path)
        }

        if derived_data.empty?
          raise 'Any matching derived data are not found'.red
        end

        derived_data.max { |data| data.updated_at }
      end

      def derived_data_root
        File.expand_path('~/Library/Developer/Xcode/DerivedData')
      end
    end

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
