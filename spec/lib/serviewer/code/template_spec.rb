require 'spec_helper'
require('ostruct')

describe Template do
  context 'Init thru spec_helper' do

    it '#paths' do
      expect { described_class.paths }.to_not raise_error
    end

    it '#paths' do
      expect( described_class.paths ).to include( "templates/digest_rails_specs/all/one_level" )
    end

    context 'with one-level template, one-level context' do

      before :each do
        @one_level_context = OpenStruct.new(text: 'Hello World')
        @one_level_hash_context = {text: 'Hello World'}
        @one_level_template = Template['digest_rails_specs/all/one_level']
      end

      it '@template.render @contenxt' do
        expect( @one_level_template.render(@one_level_context) ).to eq("DIALOG : Hello World")
      end

      it '@template.render @contenxt' do
        expect( @one_level_template.render(@one_level_hash_context) ).to eq("DIALOG : Hello World")
      end

    end

    context 'with two-level template, one-level context' do

      before :each do
        @one_level_context = OpenStruct.new(top_text: 'Hello World', bottom_text: 'Goodbye World')
        @one_level_hash_context = {top_text: 'Hello World', bottom_text: 'Goodbye World'}
        @two_level_template = Template['digest_rails_specs/all/two_level_template_one_level_context']
      end

      it '@template.render @context' do
        expect( @two_level_template.render(@one_level_context) ).to eq("Top : Hello World\nBottom : Goodbye World")
      end

      it '@template.render @context' do
        expect( @two_level_template.render(@one_level_hash_context) ).to eq("Top : Hello World\nBottom : Goodbye World")
      end

    end

    context 'with two-level template, two-level context' do

      before :each do
        @two_level_context = OpenStruct.new(
            top_text: 'Hello World',
            bottom_object: OpenStruct.new({ :bottom_text => 'Goodbye World' })
        )

        @two_level_hash_context = {
            top_text: 'Hello World',
            bottom_object: { bottom_text: 'Goodbye World' }
        }

        @two_level_template = Template['digest_rails_specs/all/two_level_template_two_level_context']
      end

      it '@template.render @contenxt' do
        expect( @two_level_template.render(@two_level_context) ).to eq("Top : Hello World\nBottom : Goodbye World")
      end

      it '@template.render @contenxt' do
        expect( @two_level_template.render(@two_level_hash_context) ).to eq("Top : Hello World\nBottom : Goodbye World")
      end

    end


  end
end
