require "xctracker/derived_data"
require "xctracker/execution"
require "xctracker/tracker"
require "xctracker/version"
require  "xctracker/reporters/standard_output_reporter"
require 'colorize'
require 'optparse'
require 'ostruct'

module Xctracker
  class << self
    def execute(args)
      options = OpenStruct.new
      options.order = :time
      options.reporters = [:standard_output]

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: xctracker [filename] [options]".red

        opts.on("-v", "--[no-]verbose", "Show invalid location results") { |v| options.verbose = v }
        opts.on("-o [ORDER]", [:default, :time, :file], "Sort order") { |v| options.order = v }
        opts.on("-r", "--reporters", Array, "List of reporter names") { |v| options.reporters = v }
        opts.on("-l", "--limit [LIMIT]", Integer, "Limit for display") { |v| options.limit = v }
      end
      parser.parse!(args)

      product_name = args.pop
      unless product_name
        raise "Usage: xctracker [product_name] [options]".red
        exit 1
      end

      tracker = Tracker.new(product_name, options)
      tracker.report!
    end
  end
end
