class ReadmeController < UIViewController

  attr_accessor :repo

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchReadme
  end

  def performHousekeepingTasks
    self.navigationItem.title = "#{repo.name}'s README"
    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)
  end

  def registerEvents
    'RepoReadmeFetched'.add_observer(self, 'displayReadmeContent')
  end

  def displayReadmeContent
    bundle = NSBundle.mainBundle
    readmeFile = bundle.pathForResource('html/readme', ofType: 'html')
    html = NSString.stringWithContentsOfFile(readmeFile, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{readme_content}}', withString: @repo.readme.content)
    @fileWebView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end