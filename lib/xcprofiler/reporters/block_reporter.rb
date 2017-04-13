module Xcprofiler
  class BlockReporter < AbstractReporter
    def initialize(options = {}, &block)
      raise ArgumentError, '[BlockReporter] block must be passed' unless block_given?
      super(options)
      @block = block
    end

    def report!(executions)
      @block.call(executions)
    end
  end
end
