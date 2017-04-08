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
        expect(filtered_executions.size).to eql(1)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end
    end

    context 'with order' do
      let(:reporter) { AbstractReporter.new({order: order, allow_duplicated: true}) }

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
      let(:reporter) { AbstractReporter.new({limit: 5, allow_duplicated: true}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(5)
        expect(filtered_executions.first).to eql(valid_executions.last)
      end

    end

    context 'with threshold' do
      context 'with 0' do
        let(:reporter) { AbstractReporter.new({threshold: 0, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(10)
          expect(filtered_executions.first).to eql(valid_executions.last)
        end  
      end
    
      context 'with 1' do
        let(:reporter) { AbstractReporter.new({threshold: 1, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(9)
          expect(filtered_executions.first).to eql(valid_executions.last)
        end
      end

      context 'with 9' do
        let(:reporter) { AbstractReporter.new({threshold: 9, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(1)
          expect(filtered_executions.first).to eql(valid_executions.last)
        end
      end

      context 'with 10' do
        let(:reporter) { AbstractReporter.new({threshold: 10, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(0)
          expect(filtered_executions.first).to be_nil
        end
      end

    end

    context 'with show_invalid_locations' do
      let(:reporter) { AbstractReporter.new({show_invalid_locations: true, allow_duplicated: true}) }

      it 'returns filtered executions' do
        expect(filtered_executions.size).to eql(20)
        expect(filtered_executions.first).to eql(invalid_executions.last)
      end
    end

    context 'with multi_options' do
      let(:order) { :file }
      let(:limit) { 5 }
      let(:threshold) { 1 }
      let(:show_invalid_locations) { true }
      context 'with order and limit' do
        let(:reporter) { AbstractReporter.new({order: order, limit: limit, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(valid_executions.first)
        end
      end

      context 'with order and threshold' do
        let(:reporter) { AbstractReporter.new({order: order, threshold: threshold, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(9)
          expect(filtered_executions.first).to eql(valid_executions[1])
        end
      end

      context 'with order and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({order: order, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(20)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with limit and threshold' do
        let(:reporter) { AbstractReporter.new({limit: limit, threshold: threshold, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(valid_executions.last)
        end
      end

      context 'with limit and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({limit: limit, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with threshold and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({threshold: threshold, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(18)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with order, limit and threshold' do
        let(:reporter) { AbstractReporter.new({order: order, limit: limit, threshold: threshold, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(valid_executions[1])
        end
      end

      context 'with order, limit and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({order: order, limit: limit, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with order, threshold and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({order: order, threshold: threshold, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(18)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with limit, threshold and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({limit: limit, threshold: threshold, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end

      context 'with order, limit, threshold and show_invalid_locations' do
        let(:reporter) { AbstractReporter.new({order: order, limit: limit, threshold: threshold, show_invalid_locations: show_invalid_locations, allow_duplicated: true}) }

        it 'returns filtered executions' do
          expect(filtered_executions.size).to eql(limit)
          expect(filtered_executions.first).to eql(invalid_executions.last)
        end
      end
    end 
  end
end
