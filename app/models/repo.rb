class Repo

  include AFNetWorking

  attr_accessor :data, :owner, :issues

  def initialize(data={})
    @data = data
    @issues = []
  end

  def name
    @data[:name]
  end

  def fullName
    "#{owner.login}/#{name}"
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
    @owner ||= User.new(@data[:owner])
  end

  def forked?
    @data[:fork].to_s == 'true'
  end

  def private?
    @data[:private].to_s == 'true'
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
        branches = result.object.collect { |b| Branch.new(b) }
        'RepoBranchesFetched'.post_notification(branches)
      else
        puts "failed fetching branches"
        puts result.error.localizedDescription
      end
    end
  end

  def fetchIssues(page=1)
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/issues", access_token: AppHelper.getAccessToken, page: page) do |result|
      if result.success?
        self.issues = result.object.collect { |i| Issue.new(i) }
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
        contributions = result.object.collect { |o| Contribution.new(o) }
        'ContributorsFetched'.post_notification(contributions)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def fetchCommitActivity
    buildHttpClient
    AFMotion::Client.shared.get("/repos/#{fullName}/stats/commit_activity", access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        puts 'fetching commit activity'
        commit_activities = result.object.collect { |o| CommitActivity.new(o) }
        'CommitActivityDataFetched'.post_notification(commit_activities)
      else
        puts result.error.localizedDescription
      end
    end
  end

  def commitActivityApiUrl
    "#{GITHUB_API_HOST}/repos/#{fullName}/stats/commit_activity?access_token=#{AppHelper.getAccessToken}"
  end

  def punchCardApiUrl
    "#{GITHUB_API_HOST}/repos/#{fullName}/stats/punch_card?access_token=#{AppHelper.getAccessToken}"
  end

end