class CommitActivity

  attr_accessor :data

  def initialize(data={})
    @data = {}
  end

  def total
    @data[:total]
  end

  def week
    @data[:week]
  end

end