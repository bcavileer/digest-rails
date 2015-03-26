require 'spec_helper'

describe ContextHash do

  it 'exists' do
    expect { described_class }.to_not raise_error
  end

  it 'can create object from hash wo error' do
    expect { described_class.create(a: 1) }.to_not raise_error
  end

  context 'with a created single-layer object' do
    before :each do
      @instance = described_class.create(a: 1)
    end

    it 'returns key value' do
      expect( @instance.a ).to eq(1)
    end

    it 'returns nil for undefined key' do
      expect( @instance.b ).to be nil
    end

  end

  context 'with a created single-layer object' do

    before :each do
      @instance = described_class.create(a: 1,b:{c: 2})
    end

    it 'returns key value' do
      expect( @instance.a ).to eq(1)
    end

    it 'returns key value' do
      expect( @instance.b.c ).to eq(2)
    end

  end

end
