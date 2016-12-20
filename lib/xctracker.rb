require "xctracker/derived_data"
require "xctracker/execution"
require "xctracker/tracker"
require "xctracker/version"
require 'colorize'
require 'optparse'

module Xctracker
  class << self
    def execute(args)
      product_name = args.pop
      unless product_name
        raise "Usage: xctracker [product_name] [options]".red
        exit 1
      end

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: xctracker [filename] [options]".red

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options[:verbose] = v
        end
      end
      options = parser.parse!(args)
      Tracker.report(product_name, options)
    end
  end
end
