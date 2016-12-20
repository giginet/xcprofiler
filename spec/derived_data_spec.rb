require 'spec_helper'
include Xctracker

describe DerivedData do

  before do
    fixture_root = File.absolute_path(File.join(__FILE__, '../fixtures'))
    allow(DerivedData).to receive(:derived_data_root).and_return(fixture_root)
  end

  describe '#by_product_name' do
    context "with existing product name" do
      it 'returns DerivedData' do
        derived_data = DerivedData.by_product_name('MyApp')
        expect(derived_data).to_not be_nil
      end
    end

    context 'with not existing product name' do
      it 'raises' do
        expect {
          DerivedData.by_product_name('Invalid')
        }.to raise_error('Any matching derived data are not found'.red)
      end
    end
  end
end
