class ContributionsController < UIViewController
  
  attr_accessor :user
  
  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    showContributions
  end
  
  def performHousekeepingTasks
    self.navigationItem.title = "#{user.login}'s Contributions"
    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)
  end
  
  def showContributions
    bundle = NSBundle.mainBundle
    contributions = bundle.pathForResource('html/contributions', ofType: 'html')
    html = NSString.stringWithContentsOfFile(contributions, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{user_login}}', withString: @user.login)
    @fileWebView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end
  
end