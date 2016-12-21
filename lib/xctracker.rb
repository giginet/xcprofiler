require "xctracker/derived_data"
require "xctracker/exceptions"
require "xctracker/execution"
require "xctracker/tracker"
require "xctracker/version"
require "xctracker/reporters/abstract_reporter"
require "xctracker/reporters/standard_output_reporter"
require "xctracker/reporters/json_reporter"
require "colorize"
require "optparse"
require "ostruct"

module Xctracker
  class << self
    def execute(args)
      options = OpenStruct.new
      options.order = :time
      options.reporters = [:standard_output]

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: xctracker [product name or .xcactivitylog file] [options]".red

        opts.on("--[no-]show-invalids", "Show invalid location results") { |v| options.show_invalid_locations = v }
        opts.on("-o [ORDER]", [:default, :time, :file], "Sort order") { |v| options.order = v }
        opts.on("-l", "--limit [LIMIT]", Integer, "Limit for display") { |v| options.limit = v }
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
      parser.parse!(args)

      target = args.pop
      unless target
        puts parser
        exit 1
      end

      order = options[:order] or :time

      begin
        if target.end_with?('.xcactivitylog')
          tracker = Tracker.by_path(target)
        else
          tracker = Tracker.by_product_name(target)
        end
        tracker.reporters = [
          StandardOutputReporter.new(limit: options[:limit],
                                     order: order,
                                     show_invalid_locations: options[:show_invalid_locations])
        ]
        tracker.report!
      rescue Exception => e
        puts e.message.red
      end
    end
  end
end
