class CommitActivityController < UIViewController

  attr_accessor :repo

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    renderActivities
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Commit Activity'
    @fileWebview = createWebView
    self.view.addSubview(@fileWebview)
  end

  def renderActivities
    bundle = NSBundle.mainBundle
    commitActivity = bundle.pathForResource('html/commit_activity', ofType: 'html')
    html = NSString.stringWithContentsOfFile(commitActivity, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{commit_activity_url}}', withString: @repo.commitActivityApiUrl)
    @fileWebview.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end