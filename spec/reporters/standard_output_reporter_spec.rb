require 'spec_helper'
include Xcprofiler

describe StandardOutputReporter do
  let(:profiler) do
    Profiler.by_product_name('MyApp').tap do |profiler|
      profiler.reporters = [reporter]
    end
  end
  let(:reporter) { StandardOutputReporter.new }

  before do
    fixture_root = File.absolute_path(File.join(__FILE__, '../../fixtures'))
    allow(DerivedData).to receive(:default_derived_data_root).and_return(fixture_root)
    allow(reporter).to receive(:table_for)
  end

  it 'exports json' do
    profiler.report!
    expect(reporter).to have_received(:table_for)
  end

  describe '#truncate' do
    context 'with a valid value' do
      it { expect(reporter.send(:truncate, "x" * 10, 10)).to eql("x" * 7 + "...") }
    end

    context 'with too short text' do
      it { expect(reporter.send(:truncate, "x" * 9, 10)).to eql("x" * 9) }
    end

    context 'with too short truncate_at' do
      it { expect(reporter.send(:truncate, "x" * 10 , 2)).to eql("x" * 10) }
    end
  end
end
