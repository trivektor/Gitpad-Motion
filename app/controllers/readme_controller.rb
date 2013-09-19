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

    if @repo.readme
      html = html.stringByReplacingOccurrencesOfString('{{readme_content}}', withString: @repo.readme.content)
    else
      html = 'This repo does not seem to have README file'
      createReadmeBtn
    end
    @fileWebView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

  private

  def createReadmeBtn
    readmeBtn = createFontAwesomeButton(
      icon: 'file-alt',
      touchHandler: 'showReadmeEditor'
    )
    self.navigationItem.setRightBarButtonItem(readmeBtn)
  end

  def showReadmeEditor
    readmeEditorController = ReadmeEditorController.alloc.init
    readmeEditorController.repo = @repo
    navController = UINavigationController.alloc.initWithRootViewController(readmeEditorController)
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    self.presentViewController(navController, animated: true, completion: nil)
  end

end