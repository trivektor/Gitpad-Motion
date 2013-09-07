class NewsfeedDetailsController < UIViewController

  attr_accessor :event

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    self.navigationItem.title = 'Details'
    performHousekeepingTasks
    loadNewsfeed
  end

  def performHousekeepingTasks
    createBackButton
    @wview = UIWebView.alloc.initWithFrame(self.view.bounds)
    @wview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @wview.delegate = self
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