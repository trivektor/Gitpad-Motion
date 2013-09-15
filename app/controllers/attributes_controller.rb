class AttributionsController < UIViewController

  def viewDidLoad
    super

    self.navigationItem.title = 'Attributions'
    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)

    bundle = NSBundle.mainBundle
    attributions = bundle.pathForResource('html/attributions', ofType: 'html')
    html = NSString.stringWithContentsOfFile(attributions, encoding: NSUTF8StringEncoding, error: nil)
    @fileWebView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end