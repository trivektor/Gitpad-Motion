class GistFile

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def name
    @data[:filename]
  end

  def rawUrl
    @data[:raw_url]
  end

  def size
    @data[:size]
  end

end

class Gist

  include AFNetWorking

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

  def files
    return [] if @data[:files].empty?
    @files ||= @data[:files].collect { |name, info| GistFile.new(info) }
  end

  def numFiles
    files.count
  end

  def numForks
    @data[:forks].to_a.count
  end

  def numComments
    @data[:comments].to_i
  end

  def public?
    @data[:public].to_s == 'true'
  end

  def fetchStats
    buildHttpClient
    AFMotion::Client.shared.get("/gists/#{id}", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        gist = Gist.new(result.object)
        'GistStatsFetched'.post_notification(gist)
      else
        puts result.error.localizedDescription
      end
    end
  end

end