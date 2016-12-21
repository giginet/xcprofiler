require 'spec_helper'
include Xctracker

describe Tracker do

  before do
    fixture_root = File.absolute_path(File.join(__FILE__, '../fixtures'))
    allow(DerivedData).to receive(:derived_data_root).and_return(fixture_root)
  end

  let(:tracker) { Tracker.new(derived_data) }

  context 'with flag not enabled data' do
    let(:derived_data) { DerivedData.by_product_name('Invalid') }

    describe '#report!' do
      it 'raises error' do
        expect {
          tracker.report!
        }.to raise_error(BuildFlagIsNotEnabled, "'-Xfrontend -debug-time-function-bodies' flag is not enabled")
      end
    end
  end

  context 'with valid data' do
    let(:derived_data) { DerivedData.by_product_name('MyApp') }

    describe '#report' do
      let(:reporter) { double('Reporter') }
      before do
        allow(reporter).to receive(:report!).with(an_instance_of(Array))
        tracker.reporters = [reporter]
      end

      it 'reporters are invoked' do
        tracker.report!
        expect(reporter).to have_received(:report!).with(an_instance_of(Array))
      end
    end
  end
end
