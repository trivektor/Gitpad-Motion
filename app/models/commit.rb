class Commit

  attr_accessor :data, :details, :parent

  def initialize(data={})
    @data = data
  end

  def url
    @data[:url]
  end

  def sha
    @data[:sha]
  end

  def commentsUrl
    @data[:comments_url]
  end

  def details
    @details ||= @data[:commit]
  end

  def message
    details[:message]
  end

  def parent
    @parent ||= @data[:parents]
  end

  def parentSha
    parent[:sha]
  end

  def stats
    @data[:stats]
  end

  def files
    @data[:files]
  end

  def author
    @author ||= User.new(@data[:author])
  end

  def commitedAt
    @data[:commit][:author][:date]
  end

end