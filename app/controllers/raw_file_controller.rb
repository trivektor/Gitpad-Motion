class RawFileController < UIViewController

  attr_accessor :fileWebView, :fileName, :mimeType, :rawFileRequest, :repo, :branch, :themeOptions

  CSS_FILES = [
    'prettify.css',
    'desert.css',
    'sunburst.css',
    'son-of-obsidian.css',
    'doxy.css'
  ]

  THEMES_MENU = [
    'Default',
    'Desert',
    'Sunburst',
    'Sons of Obsidian',
    'Doxy'
  ]

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @nodes = []
    self
  end

  def viewDidLoad
    super
    createBackButton
    loadHud
    performHousekeepingTasks
    fetchRawFile
  end

  def performHousekeepingTasks
    self.navigationItem.title = @fileName

    @fileWebView = UIWebView.alloc.initWithFrame(self.view.bounds)
    @fileWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @fileWebView.delegate = self

    self.view.addSubview(@fileWebView)
  end

  def connection(connection, didReceiveResponse: response)
    @mimeType = response.MIMEType
  end

  def connection(connection, didReceiveData: data)
    image = UIImage.imageWithData(data)

    if image
      @fileWebView.loadRequest(@rawFileRequest)
    else
      rawFilePath = NSBundle.mainBundle.pathForResource('html/raw_file', ofType: 'html')
      rawFileContent = NSString.stringWithContentsOfFile(rawFilePath, encoding: NSUTF8StringEncoding, error: nil)
      content = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)

      @cssFile = CSS_FILES.first

      htmlString = rawFileContent.stringByReplacingOccurrencesOfString('{{css_file}}', withString: @cssFile)
                                 .stringByReplacingOccurrencesOfString('{{content}}', withString: encodeHtmlEntities(content))
      @fileWebView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle.bundlePath.nsurl)

      addThemeButton
      hideHud
    end
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    unless buttonIndex == @themeOptions.cancelButtonIndex
      @cssFile = CSS_FILES[buttonIndex]
      fetchRawFile
    end
  end

  def switchTheme
    @themeOptions = UIActionSheet.alloc

    @themeOptions.send(:'initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:',
      'Switch Theme',
      self,
      'Cancel',
      nil,
      'Default', 'Desert', 'Sunburst', 'Sons of Obsidian', 'Doxy', nil
    )
    @themeOptions.actionSheetStyle = UIActionSheetStyleBlackOpaque
    @themeOptions.showInView(UIApplication.sharedApplication.keyWindow)
  end

  private

  def fetchRawFile
    showHud

    blobPaths = []

    self.navigationController.viewControllers.each do |controller|
      if controller.is_a? RepoTreeController
          blobPaths << controller.node.path unless controller.node.nil?
      end
    end

    paths = []
    paths << @repo.fullName unless @repo.nil?
    paths << @branch.name unless @branch.nil?
    paths << blobPaths.join('/') unless blobPaths.empty?
    paths << @fileName

    @rawFileRequest = NSURLRequest.requestWithURL("#{RAW_GITHUB_HOST}/#{paths.join('/')}".nsurl)
    rawFileConnection = NSURLConnection.connectionWithRequest(@rawFileRequest, delegate: self)
    rawFileConnection.start
  end

  def encodeHtmlEntities(rawString)
    rawString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
             .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end

  def addThemeButton
    @switchThemeBtn = UIBarButtonItem.alloc.initWithTitle('Switch Theme',
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: 'switchTheme')
    self.navigationItem.setRightBarButtonItem(@switchThemeBtn)
  end

end