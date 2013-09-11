class Readme

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def path
    @data[:path]
  end

  def content
    content = NSData.dataFromBase64String(@data[:content].to_s).nsstring
    MMMarkdown.HTMLStringWithMarkdown(content, error: nil)
  end

  def sha
    @data[:sha]
  end

  def url
    @data[:url]
  end

  def gitUrl
    @data[:git_url]
  end

  def htmlUrl
    @data[:html_url]
  end

end