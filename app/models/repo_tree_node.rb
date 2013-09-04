class RepoTreeNode

  include AFNetWorking

  attr_accessor :data

  def initialize(data={})
    @data = data
  end

  def type
    @data[:type]
  end

  def path
    @data[:path]
  end

  def sha
    @data[:sha]
  end

  def mode
    @data[:mode]
  end

  def size
    @data[:size].to_i
  end

  def url
    @data[:url]
  end

  def tree?
    type == 'tree'
  end

  def blob?
    type == 'blob'
  end

  def fetchTree
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        nodes = result.object[:tree].collect { |n| RepoTreeNode.new(n) }
        'TreeFetched'.post_notification(nodes)
      else
        puts result.error.localizedDescription
      end
    end
  end

end