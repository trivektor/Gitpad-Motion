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
    registerEvents
    @repo.fetchCommitActivity
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Commit Activity'

    @fileWebview = UIWebView.alloc.initWithFrame(self.view.bounds)
    @fileWebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @fileWebview.delegate = self

    self.view.addSubview(@fileWebview)
  end

  def registerEvents
    'CommitActivityDataFetched'.add_observer(self, :'renderActivities:')
  end

  def renderActivities(notification)
    bundle = NSBundle.mainBundle
    commitActivity = bundle.pathForResource('html/commit_activity', ofType: 'html')
    html = NSString.stringWithContentsOfFile(commitActivity, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{commit_activity_url}}', withString: @repo.commitActivityApiUrl)
    @fileWebview.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end