class Repo

  include AFNetWorking
  extend AFNetWorking
  include RelativeTime

  attr_accessor :data, :owner, :issues, :branches, :contributors, :readme, :languages, :forks, :watchers

  def initialize(data={})
    @data = data
    @issues = []
    @branches = []
    @contributors = []
    @languages = []
    @forks = []
    @watchers = []
  end

  def name
    @data[:name]
  end

  def fullName
    @data[:full_name]
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

  def relativePushedAt
    relativeTime(pushedAt).downcase
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
    @owner ||= User.new(@data[:owner])
  end

  def forked?
    @data[:fork].to_s == 'true'
  end

  def private?
    @data[:private].to_s == 'true'
  end

  def editable?
    currentUser = CurrentUserManager.sharedInstance
    owner.login == currentUser.login
  end

  def treeUrl
    "#{fullName}/git/trees"
  end

  def fetchFullInfo
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        'RepoInfoFetched'.post_notification(Repo.new(result.object))
      else
        puts "failed fetching full info"
        puts result.error.localizedDescription
      end
    end
  end

  def fetchBranches
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/branches", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @branches = result.object.collect { |b| Branch.new(b) }
        'RepoBranchesFetched'.post_notification
      else
        puts "failed fetching branches"
        puts result.error.localizedDescription
      end
    end
  end

  def fetchWatchers(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/watchers", access_token: AppHelper.getAccessToken, page: page) do |result|
      if result.success?
        @watchers += result.object.collect { |o| User.new(o) }
        'RepoWatchersFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchForks(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/forks", access_token: AppHelper.getAccessToken, page: page) do |result|
      if result.success?
        @forks = result.object.collect { |o| Repo.new(o) }
        'RepoForksFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchIssues(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/issues", access_token: AppHelper.getAccessToken, page: page) do |result|
      if result.success?
        @issues = result.object.collect { |i| Issue.new(i) }
        'RepoIssuesFetched'.post_notification
      else
      end
    end
  end

  def fetchTopLayerForBranch(branch)
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{treeUrl}/#{branch.name}", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        nodes = result.object[:tree].collect { |o| RepoTreeNode.new(o) }
        'TreeFetched'.post_notification(nodes)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchContributors
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/stats/contributors", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @contributors = result.object.collect { |o| Contribution.new(o) }
        'ContributorsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchReadme
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/readme", access_token: AppHelper.getAccessToken) do |result|
      self.readme = result.success? ? Readme.new(result.object) : nil
      'RepoReadmeFetched'.post_notification
    end
  end

  def fetchLanguages
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/languages", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        total = result.object.values.inject(:+)
        @languages.clear
        result.object.each { |k, v| @languages << {name: k, percentage: (v*100.0/total).round(2)} }
        'RepoLanguagesFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

  def createNew(params={})
    # buildHttpClient(parameter_encoding: false)
    # AFMotion::Client.shared.post("/user/repos", params.merge(access_token: AppHelper.getAccessToken)) do |result|
    #   if result.success?
    #
    #   else
    #     puts result.error.localizedDescription
    #   end
    # end
  end

  def commitActivityApiUrl
    "#{GITHUB_API_HOST}/repos/#{fullName}/stats/commit_activity?access_token=#{AppHelper.getAccessToken}"
  end

  def punchCardApiUrl
    "#{GITHUB_API_HOST}/repos/#{fullName}/stats/punch_card?access_token=#{AppHelper.getAccessToken}"
  end

end