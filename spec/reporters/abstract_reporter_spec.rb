require 'spec_helper'
include Xcprofiler

describe AbstractReporter do
  let(:valid_executions) do
    10.times.map { |time| Execution.new("#{time}ms", "/path/to/Source.swift:#{10 + time}:20", "get()") }
  end
  let(:invalid_executions) do
    10.times.map { |time| Execution.new("#{time}ms", "<invalid loc>", "get()") }
  end
  let(:executions) { valid_executions + invalid_executions }

  describe '#filter_executions' do
    let(:filtered_executions) { reporter.filter_executions(executions) }
    context 'with no options' do
      let(:reporter) { AbstractReporter.new }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(10)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end
    end

    context 'with order' do
      let(:reporter) { AbstractReporter.new({order: order}) }

      context 'with :time' do
        let(:order) { :time }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(10)
          expect(filtered_executions.first).to eql(valid_executions.last)
        end
      end

      context 'with :file' do
        let(:order) { :file }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(10)
          expect(filtered_executions.first).to eql(valid_executions.first)
        end
      end

      context 'with :default' do
        let(:order) { :default }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(10)
          expect(filtered_executions.first).to eql(valid_executions.first)
        end
      end

    end

    context 'with limit' do
      let(:reporter) { AbstractReporter.new({limit: 5}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(5)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end

    end

    context 'with lower_limit 0' do
      let(:reporter) { AbstractReporter.new({lower_limit: 0}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(10)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end

    end

    context 'with lower_limit 1' do
      let(:reporter) { AbstractReporter.new({lower_limit: 1}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(9)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end

    end

    context 'with lower_limit 9' do
      let(:reporter) { AbstractReporter.new({lower_limit: 9}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(1)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end

    end

    context 'with lower_limit 10' do
      let(:reporter) { AbstractReporter.new({lower_limit: 10}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(0)
        expect(filtered_executions.first).to be_nil
      end

    end

    context 'with show_invalid_locations' do
      let(:reporter) { AbstractReporter.new({show_invalid_locations: true}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(20)
        expect(filtered_executions.first).to eql(invalid_executions.last)
      end
    end
  end
end
