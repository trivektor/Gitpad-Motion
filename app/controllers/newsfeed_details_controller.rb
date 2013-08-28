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
    mainBundle = NSBundle.mainBundle

    html = NSString.stringWithContentsOfFile(
      mainBundle.pathForResource('html/newsfeed', ofType: 'html'),
      encoding: NSASCIIStringEncoding,
      error: nil)

    contentHtml = html.stringByReplacingOccurrencesOfString('%@', withString: 'abc')

    data = contentHtml.dataUsingEncoding(NSUTF8StringEncoding)
    @wview.loadData(data, MIMEType: 'text/html', textEncodingName: 'utf-8', baseURL: NSURL.fileURLWithPath(mainBundle.bundlePath))
    # @wview.loadHTMLString(contentHtml, baseUrl: )
  end

  def webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
    true
  end

end