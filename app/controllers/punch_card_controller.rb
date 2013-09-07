class PunchCardController < UIViewController

  attr_accessor :repo

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    renderPunchCard
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Punch Card'

    @fileWebview = UIWebView.alloc.initWithFrame(self.view.bounds)
    @fileWebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @fileWebview.delegate = self

    self.view.addSubview(@fileWebview)
  end

  def renderPunchCard
    bundle = NSBundle.mainBundle
    commitActivity = bundle.pathForResource('html/punch_card', ofType: 'html')
    html = NSString.stringWithContentsOfFile(commitActivity, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{punch_card_url}}', withString: @repo.punchCardApiUrl)
    @fileWebview.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end