class Branch

  attr_accessor :data, :commit

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def sha
    @data[:sha]
  end

  def commit
    @commit ||= Commit.new(@data[:commit])
  end

  def commitsUrl
    @data[:url]
  end

end
