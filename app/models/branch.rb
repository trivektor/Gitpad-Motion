class Branch

  include AFNetWorking

  attr_accessor :data, :commit, :endSha

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def sha
    commit.sha
  end

  def commit
    @commit ||= Commit.new(@data[:commit])
  end

  def commitsUrl
    commit.url
  end

  def commitsIndexUrl
    commitsUrl.gsub(sha, '')[0..-2]
  end

  def fetchCommits(page=1)
    buildHttpClient

    if @endSha.nil?
      sha = self.sha
      startIndex = 0
    else
      sha = @endSha
      startIndex = 1
    end

    AFMotion::Client.shared.get(commitsIndexUrl, access_token: AppHelper.getAccessToken, sha: sha, page: page) do |result|
      if result.success?
        commits = result.object.drop(startIndex).collect { |o| Commit.new(o) }
        @endSha = commits.last.sha
        'CommitsFetched'.post_notification(commits)
      else
        puts result.error.localizedDescription
      end
    end
  end

end
