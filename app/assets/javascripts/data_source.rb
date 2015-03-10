require 'columns'

class DataSource
  attr_accessor :columns, :digest

  def initialize()
    @columns = Columns.new(self)
  end

end