class NewsfeedDetailsController < UIViewController

  attr_accessor :event

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    loadNewsfeed
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Details'

    @wview = createWebView
    self.view.addSubview(@wview)
  end

  def loadNewsfeed
    bundle = NSBundle.mainBundle
    newsfeed = bundle.pathForResource('html/newsfeed', ofType: 'html')
    html = NSString.stringWithContentsOfFile(newsfeed, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('%@', withString: self.event.toHtmlString)
    @wview.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

  def webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
    true
  end

end