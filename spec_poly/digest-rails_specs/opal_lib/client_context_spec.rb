#require 'spec_helper'
class RenderContext
  def initialize(h)
  end
  def fullname
  end
end

describe ClientContext do

    before :each do
      @client_context = ClientContext.new
    end

    it '.list respond_to' do
      expect @client_context.respond_to? :list
    end

    it '.references respond_to' do
      expect @client_context.respond_to? :references
    end

    it '.cursor respond_to' do
      expect @client_context.respond_to? :cursor
    end

    context 'after init' do
      before :each do
        @client_context.init
      end

      it '.list has 1 key' do
        expect @client_context.list.keys.length == 1
      end

      it '.list {>root<=>first_cursor}' do
        expect @client_context.list.keys.first == 'root'
      end

      it '.references has 1 key' do
        expect @client_context.list.keys.length == 1
      end

      it '.references {>first_cursor<=>first_cursor}' do
        expect @client_context.list.keys.first == 'first_cursor'
      end

      #first_cursor = RenderContext.new(
      #    dir: self,
      #    root: true,
      #    name: 'root',
      #    parent: nil

    end
end
