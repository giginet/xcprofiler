require 'spec_helper'
include Xctracker

describe Execution do
  context 'with location' do

  end

  context 'with invalid location' do
    let(:execution) { Execution.new('0.2ms', '/path/to/Source.swift:10:20', 'get') }

    describe '#invalid?' do
      it 'returns false' do
        expect(execution.invalid?).to be_falsey
      end
    end

    describe '#path' do
      it 'returns path' do
        expect(execution.path).to eql('/path/to/Source.swift')
      end
    end

    describe '#filename' do
      it 'returns filename' do
        expect(execution.filename).to eql('Source.swift')
      end
    end

    describe '#column' do
      it 'returns column' do
        expect(execution.column).to eql(20)
      end
    end

    describe '#line' do
      it 'returns line' do
        expect(execution.line).to eql(10)
      end
    end

    describe '#to_h'  do
      it 'returns hash' do
        expect(execution.to_h).to eql({ method_name: 'get',
                                        time: 0.2,
                                        path: '/path/to/Source.swift',
                                        line: 10,
                                        column: 20
                                      })
      end
    end
  end

  context 'with invalid location' do
    let(:execution) { Execution.new('0.2ms', '<invalid loc>', 'get') }

    describe '#invalid?' do
      it 'returns true' do
        expect(execution.invalid?).to be_truthy
      end
    end

    describe '#path' do
      it 'returns nil' do
        expect(execution.path).to be_nil
      end
    end

    describe '#filename' do
      it 'returns nil' do
        expect(execution.filename).to be_nil
      end
    end

    describe '#column' do
      it 'returns nil' do
        expect(execution.column).to be_nil
      end
    end

    describe '#line' do
      it 'returns nil' do
        expect(execution.line).to be_nil
      end
    end

    describe '#to_h'  do
      it 'returns hash' do
        expect(execution.to_h).to eql({ method_name: 'get',
                                        time: 0.2,
                                        path: nil,
                                        line: nil,
                                        column: nil
                                      })
      end
    end
  end
end
