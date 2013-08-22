class Authorization

  def initialize(data={})
    @data = data
  end

  def name
    @data[:app][:name]
  end

  def id
    @data[:id]
  end

  def token
    @data[:token]
  end

end