class ReadmeEditorController < UIViewController

  attr_accessor :repo

  def viewDidLoad
    super
    performHouskeepingTasks
    createBackButton
  end

  def performHouskeepingTasks
    self.navigationItem.title = 'Add Readme'
    @fileWebView = createWebView
    self.view.addSubview(@fileWebView)

    initializeEditor
  end

  def popBack
    self.dismissViewControllerAnimated(true, completion: nil)
  end

  private

  def initializeEditor
    bundle = NSBundle.mainBundle
    readme_editor = bundle.pathForResource('html/readme_editor', ofType: 'html')

    jquery = bundle.pathForResource('html/jquery', ofType: 'js')
    bootstrapMarkdown = bundle.pathForResource('html/bootstrap_markdown', ofType: 'js')

    html = NSString.stringWithContentsOfFile(readme_editor, encoding: NSUTF8StringEncoding, error: nil)
    html = html.stringByReplacingOccurrencesOfString('{{jquery}}', withString: jquery)
               .stringByReplacingOccurrencesOfString('{{bootstrap_markdown}}', withString: bootstrapMarkdown)
    @fileWebView.loadHTMLString(html, baseURL: NSURL.fileURLWithPath(bundle.bundlePath))
  end

end