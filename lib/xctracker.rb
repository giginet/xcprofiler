require "xctracker/derived_data"
require "xctracker/execution"
require "xctracker/tracker"
require "xctracker/version"

module Xctracker
  class << self
    def report(args)
      filename = args.pop
      unless filename
        raise "Usage: xctracker [options]"
        exit 1
      end

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: xctracker [options]"

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options[:verbose] = v
        end
      end
      options = parser.parse!(args)
      Tracker.report(options)
    end
  end
end
