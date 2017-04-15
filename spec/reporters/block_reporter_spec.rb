require 'spec_helper'
include Xcprofiler

describe BlockReporter do
  context 'with block' do
    let(:profiler) { Profiler.by_product_name('MyApp', derived_data_root) }
    let(:derived_data_root) { File.absolute_path(File.join(__FILE__, '../../fixtures')) }

    it 'execute block' do
      called = false
      executions = nil

      profiler.reporters = [
          BlockReporter.new do |argument|
            called = true
            executions = argument
          end,
      ]
      profiler.report!
      expect(called).to be true
      expect(executions).to be_an(Array)
    end
  end

  context 'without block' do
    it 'raises error' do
      expect {
        BlockReporter.new
      }.to raise_error(ArgumentError)
    end
  end
end
