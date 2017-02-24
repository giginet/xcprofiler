require 'spec_helper'
include Xcprofiler

describe Profiler do

  before do
    fixture_root = File.absolute_path(File.join(__FILE__, '../fixtures'))
    allow(DerivedData).to receive(:default_derived_data_root).and_return(fixture_root)
  end

  let(:profiler) { Profiler.new(derived_data) }

  context 'with flag not enabled data' do
    let(:derived_data) { DerivedData.by_product_name('Invalid') }

    describe '#report!' do
      it 'raises error' do
        expect {
          profiler.report!
        }.to raise_error(BuildFlagIsNotEnabled, "'-Xfrontend -debug-time-function-bodies' flag is not enabled")
      end
    end
  end

  context 'with valid data' do
    let(:derived_data) { DerivedData.by_product_name('MyApp') }

    describe '#report' do
      let(:reporter) { double('Reporter') }
      before do
        allow(reporter).to receive(:filter_executions).with(an_instance_of(Array)).and_return([])
        allow(reporter).to receive(:report!).with(an_instance_of(Array))
        profiler.reporters = [reporter]
      end

      it 'reporters are invoked' do
        profiler.report!
        expect(reporter).to have_received(:report!).with(an_instance_of(Array))
      end
    end
  end
end
