class Contribution

  attr_accessor :data, :author

  def initialize(data={})
    @data = data
  end

  def author
    @author ||= User.new(@data[:author])
  end

  def getWeeksData
    @data[:weeks]
  end

end