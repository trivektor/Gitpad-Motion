class Repo

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def name
    @data[:name]
  end

  def fullName
    # TO BE IMPLEMENTED
  end

  def numForks
    @data[:forks].to_i
  end

  def numWatchers
    @data[:watchers].to_i
  end

  def language
    @data[:language]
  end

  def size
    @data[:size]
  end

  def url
    @data[:url]
  end

  def pushedAt
    @data[:pushed_at]
  end

  def createdAt
    @data[:created_at]
  end

  def updatedAt
    @data[:updated_at]
  end

  def description
    @data[:description]
  end

  def homepage
    @data[:homepage]
  end

  def numOpenIssues
    @data[:open_issues].to_i
  end

  def hasIssues?
    @data[:has_issues]
  end

  def owner
    User.new(@data[:owner])
  end

  def forked?
    @data[:fork].to_s == 'true'
  end

  def private?
    @data[:private].to_s == 'true'
  end

  def fetchFullInfo
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        'RepoInfoFetched'.post_notification(Repo.new(result.object))
      else
        puts result.error.localizedDescription
      end
    end
  end

  private

  def buildHttpClient
    @httpClient ||= AFMotion::Client.build_shared(GITHUB_API_HOST) do
      header "Accept", "application/json"
      parameter_encoding :json
      operation :json
    end
  end

end