require 'spec_helper'
include Xcprofiler

describe DerivedData do

  let(:derived_data_root) { File.absolute_path(File.join(__FILE__, '../fixtures')) }

  describe '#by_product_name' do
    context 'with valid log' do
      it 'returns DerivedData' do
        derived_data = DerivedData.by_product_name('MyApp', derived_data_root)
        expect(derived_data).to_not be_nil
      end

      context 'with default_derived_data_root' do
        before do
          allow(DerivedData).to receive(:default_derived_data_root).and_return(derived_data_root)
        end

        it 'returns DerivedData' do
          derived_data = DerivedData.by_product_name('MyApp', derived_data_root)
          expect(derived_data).to_not be_nil
        end
      end

      context 'with not existing log' do
        it 'raises' do
          expect {
            DerivedData.by_product_name('NotExist', derived_data_root)
          }.to raise_error(DerivedDataNotFound, 'Any matching derived data are not found')
        end
      end
    end
  end

  context 'with valid log' do
    let(:derived_data) { DerivedData.by_product_name('MyApp', derived_data_root) }

    describe '#flag_enabled?' do
      it 'returns true' do
        expect(derived_data.flag_enabled?).to be_truthy
      end
    end

    describe '#executions' do
      it 'returns array' do
        expect(derived_data.executions).not_to be_empty
      end
    end
  end

  context 'with invalid log' do
    let(:derived_data) { DerivedData.by_product_name('Invalid', derived_data_root) }

    describe '#flag_enabled?' do
      it 'returns false' do
        expect(derived_data.flag_enabled?).to be_falsey
      end
    end

    describe '#executions' do
      it 'returns empty array' do
        expect(derived_data.executions).to be_empty
      end
    end
  end
end
