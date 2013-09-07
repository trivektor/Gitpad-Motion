class Commit

  include AFNetWorking

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

  def files=(filesArray=[])
    @files = filesArray.collect { |f| CommitFile.new(f) }
  end

  def author
    @author ||= User.new(@data[:author])
  end

  def commitedAt
    @data[:commit][:author][:date]
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
    <img src='#{author.avatarUrl}' class='avatar pull-left' /> \
    authored #{author.login} \
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
      <label class='label label-important'>#{file.deletions} deletions</label> \
      </span> \
      </div> \
      <pre><code>#{file.patch}</code></pre> \
      </td> \
      </tr>"
    end

    commitDetailsPath = NSBundle.mainBundle.pathForResource('html/commit_details', ofType: 'html')
    commitDetails = NSString.stringWithContentsOfFile(commitDetailsPath, encoding: NSUTF8StringEncoding, error: nil)

    gitosCss = NSBundle.mainBundle.pathForResource('html/gitos', ofType: 'css')
    githubCss = NSBundle.mainBundle.pathForResource('html/github', ofType: 'css')

    contentHtml = commitDetails.stringByReplacingOccurrencesOfString('{{message}}', withString: commitMessageString)
                               .stringByReplacingOccurrencesOfString('{{html}}', withString: commitHtmlString)
                               .stringByReplacingOccurrencesOfString('{{gitos_css}}', withString: gitosCss)
                               .stringByReplacingOccurrencesOfString('{{github_css}}', withString: githubCss)
  end

  def fetchDetails
    buildHttpClient
    AFMotion::Client.shared.get(url, access_token: AppHelper.getAccessToken) do |result|
      if result.success?
        self.files = result.object[:files]
        'CommitDetailsFetched'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

end