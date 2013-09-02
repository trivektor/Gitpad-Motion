class Commit

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def url
    @data[:url]
  end

end