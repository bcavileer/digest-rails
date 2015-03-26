require 'spec_helper'
require 'active_support/core_ext/kernel/reporting'

describe VLogger do

  it 'exists' do
    expect { described_class }.to_not raise_error
  end

  context "Once instantiated" do

    before :each do
      @v_logger = VLogger.new
    end

    it 'logs text' do
      output = capture(:stdout) do
        @v_logger.log('text')
      end
      expect(output).to include 'text'
    end

    it 'logs text + object' do
      output = capture(:stdout) do
        @v_logger.log('text',OpenStruct.new( a: 1 ))
      end
      expect(output).to include 'a'
    end

  end

end
