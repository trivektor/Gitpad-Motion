class Gist

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def id
    @data[:id]
  end

  def description
    @data[:description]
  end

  def created_at
    @data[:created_at]
  end

  def url
    @data[:url]
  end

  def htmlUrl
    @data[:html_url]
  end

  def commentsUrl
    @data[:comments_url]
  end

  def numFiles
    @data[:files].to_i
  end

  def numForks
    @data[:forks].to_i
  end

  def numComments
    @data[:comments].to_i
  end

  def public?
    @data[:public].to_s == 'true'
  end

end