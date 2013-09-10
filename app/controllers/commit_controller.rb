class CommitController < UIViewController

  attr_accessor :commit

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @commit.fetchDetails
  end

  def performHousekeepingTasks
    self.navigationItem.title = @commit.sha

    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)
  end

  def registerEvents
    'CommitDetailsFetched'.add_observer(self, 'displayDetails')
  end

  def displayDetails
    @fileWebView.loadHTMLString(@commit.toHtmlString, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle.bundlePath))
  end

end