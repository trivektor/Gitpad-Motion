class Search

  extend AFNetWorking

  def self.user(term)
    buildHttpClient
    AFMotion::Client.shared.get("legacy/user/search/#{term}", access_token: AppHelper.getAccessToken) do |result|
      users = result.object[:users].collect { |o| User.new(o) }
      'SearchResults'.post_notification(users)
    end
  end

  def self.repo(term)
    buildHttpClient
    AFMotion::Client.shared.get("legacy/repos/search/#{term}", access_token: AppHelper.getAccessToken) do |result|
      repos = result.object[:repositories].collect { |o| Repo.new(o) }
      'SearchResults'.post_notification(repos)
    end
  end

end