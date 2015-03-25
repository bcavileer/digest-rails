require 'template'
require 'axle/opal_lib/data_source'

require 'digest-rails/opal_lib/core_pane_controller'
require 'digest-rails/opal_lib/digest_section_controller'
require 'digest-rails/opal_lib/multi_digest_controller'

require 'digest-rails/opal_lib/column_text'
require 'digest-rails/opal_lib/column_select'
require 'digest-rails/opal_lib/column_direct_attr'
require 'digest-rails/opal_lib/column_indirect_attr'

require 'digest-rails/opal_lib/base_pane_controller'

class BasePaneletController < BasePaneController
  attr_accessor :CC

  def initialize(c)
    @CC =  c[:client_context]
    CC[:template] = Template['digest-rails/views/panelets_body']
  end

  def configure(c)
    CC[:render_target] = RenderTarget.new( ".#{c[:short]}" )
    CC[:data_source] = DataSource.new(c[:model])
  end

  def config_data_source_select
    CC[:data_source].configure do |config|
      config.add_column(
          ColumnSelect.new.init(
              header:    'Select',
              prompt: '->',
              click_proc: Proc.new do |row,row_content|
                puts row
                puts row_content[:data][1]
                Dialog.set_content( row_content[:rendering] ).open
              end
          )
      )
    end
  end


end