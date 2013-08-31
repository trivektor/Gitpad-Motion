class Comment

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def user
    User.new(@data[:user])
  end

  def body
    @data[:body]
  end

  def createdAt
    @data[:created_at]
  end

  def updatedAt
    @data[:updated_at]
  end

end