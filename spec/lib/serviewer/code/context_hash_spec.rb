require 'spec_helper'

describe ContextHash do

  it 'exists' do
    expect { described_class }.to_not raise_error
  end

  it 'exists' do
    expect { described_class.create(a: 1) }.to_not raise_error
  end

  it 'returns object methods for each hash key' do
    expect { described_class.create(a: 1).a }.to_not raise_error
  end

  #it 'returns object methods for each hash key' do
  #  expect { described_class.create(a: 1).a }.to_not raise_error
  #end

  #it 'returns object from hash' do
  #  expect { described_class.create(a: 1).a }.to_not raise_error
  #end

  #it 'returns object from hash' do
  #  p described_class.create(a: 1)
  #  p described_class.create(a: 1).a
  #  p described_class.create(a: 1).b
  #  expect { described_class.create(a: 1).b }.to raise_error
  #end
end
