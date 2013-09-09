class IssueController < UIViewController

  attr_accessor :issue

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @issue.fetchComments
  end

  def performHousekeepingTasks
    self.navigationItem.title = @issue.title

    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)
  end

  def registerEvents
    'IssueCommentsFetch'.add_observer(self, 'displayComments')
  end

  def displayComments
    bundle = NSBundle.mainBundle
    issueDetailsPath = bundle.pathForResource('html/issue_details', ofType: 'html')
    issueDetails = NSString.stringWithContentsOfFile(issueDetailsPath, encoding: NSUTF8StringEncoding, error: nil)

    cssFile = bundle.pathForResource("html/gitos", ofType: 'css')

    contentHtml = issueDetails.stringByReplacingOccurrencesOfString('{{avatar}}', withString: @issue.user.avatarUrl)
                              .stringByReplacingOccurrencesOfString('{{state}}', withString: @issue.state)
                              .stringByReplacingOccurrencesOfString('{{login}}', withString: @issue.user.login)
                              .stringByReplacingOccurrencesOfString('{{created_at}}', withString: @issue.createdAt)
                              .stringByReplacingOccurrencesOfString('{{title}}', withString: @issue.title)
                              .stringByReplacingOccurrencesOfString('{{body}}', withString: @issue.body)
                              .stringByReplacingOccurrencesOfString('{{comments}}', withString: @issue.commentsHtmlString)
                              .stringByReplacingOccurrencesOfString('{{css_file}}', withString: cssFile)

    @fileWebView.loadHTMLString(contentHtml, baseURL: bundle.bundlePath.nsurl)
  end

end