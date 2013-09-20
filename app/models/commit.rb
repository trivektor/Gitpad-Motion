class Commit

  include AFNetWorking
  include RelativeTime

  attr_accessor :data, :details, :parent, :files

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
    @files ||= @data[:files].collect { |f| CommitFile.new(f) }
  end

  def author
    @author ||= User.new(@data[:author] || @data[:commit][:author])
  end

  def committedAt
    @data[:commit][:author][:date]
  end

  def relativeCommitedAt
    relativeTime(committedAt).downcase
  end

  def treeUrl
    @data[:commit][:tree][:url]
  end

  def toHtmlString
    commitHtmlString = ""

    commitMessageString = "
    <tr id='commit-overview'> \
    <td> \
    <h4>#{message}</h4> \
    <p> \
    <img src='#{author.avatarUrl || AVATAR_PLACEHOLDER}' class='avatar pull-left' /> \
    <b>#{author.login || author.name}</b> \
    authored #{relativeCommitedAt} \
    </p> \
    </td> \
    </tr>
    <tr>
    <td>Showing #{files.count} files</td>
    </tr>"

    files.each do |file|
      commitHtmlString += "<tr> \
      <td> \
      <div class='clearfix'> \
      <b class='pull-left'>#{file.name}</b> \
      <span class='pull-right commit-stats'> \
      <b>#{file.totalChanges}</b> \
      <label class='label label-success'>#{file.additions} additions</label> \
      <label class='label label-danger'>#{file.deletions} deletions</label> \
      </span> \
      </div> \
      <pre><code>#{file.patch}</code></pre> \
      </td> \
      </tr>"
    end

    bundle = NSBundle.mainBundle

    commitDetailsPath = bundle.pathForResource('html/commit_details', ofType: 'html')
    commitDetails = NSString.stringWithContentsOfFile(commitDetailsPath, encoding: NSUTF8StringEncoding, error: nil)

    gitosCss = bundle.pathForResource('html/gitos', ofType: 'css')
    githubCss = bundle.pathForResource('html/github', ofType: 'css')

    commitDetails.stringByReplacingOccurrencesOfString('{{message}}', withString: commitMessageString)
                 .stringByReplacingOccurrencesOfString('{{html}}', withString: commitHtmlString)
                 .stringByReplacingOccurrencesOfString('{{gitos_css}}', withString: gitosCss)
                 .stringByReplacingOccurrencesOfString('{{github_css}}', withString: githubCss)
  end

  def fetchDetails
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        @files = result.object[:files].collect { |f| CommitFile.new(f) }
        'CommitDetailsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

end