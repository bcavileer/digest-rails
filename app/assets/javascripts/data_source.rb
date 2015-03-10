require 'columns'

class DataSource
  attr_accessor :columns, :digests

  def initialize()
    @columns = Columns.new(self)
    @digests = []
  end

end