class FileController < UIViewController

  attr_accessor :fileWebView, :themeOptions, :mimeType

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

  def viewDidLoad
    super
    createBackButton
    loadHud
  end

  def performHousekeepingTasks
    @fileWebView = UIWebView.alloc.initWithFrame(self.view.bounds)
    @fileWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @fileWebView.delegate = self

    self.view.addSubview(@fileWebView)
  end

  def connection(connection, didReceiveResponse: response)
    @mimeType = response.MIMEType
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

  def encodeHtmlEntities(rawString)
    rawString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
             .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end

  def addThemeButton
    @switchThemeBtn = UIBarButtonItem.alloc.initWithTitle(
      FontAwesome.icon('expand'),
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: 'switchTheme')

    @switchThemeBtn.setTitleTextAttributes({
      UITextAttributeFont => FontAwesome.fontWithSize(22),
      UITextAttributeTextColor => UIColor.blackColor
    }, forState: UIControlStateNormal)

    self.navigationItem.setRightBarButtonItem(@switchThemeBtn)
  end

  def connection(connection, didReceiveData: data)
    image = UIImage.imageWithData(data)

    if image
      @fileWebView.loadRequest(@rawFileRequest)
    else
      rawFilePath = NSBundle.mainBundle.pathForResource('html/raw_file', ofType: 'html')
      rawFileContent = NSString.stringWithContentsOfFile(rawFilePath, encoding: NSUTF8StringEncoding, error: nil)
      content = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)

      htmlString = rawFileContent.stringByReplacingOccurrencesOfString('{{css_file}}', withString: @cssFile || CSS_FILES.first)
                                 .stringByReplacingOccurrencesOfString('{{content}}', withString: encodeHtmlEntities(content))
      @fileWebView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle.bundlePath.nsurl)

      addThemeButton
      hideHud
    end
  end

end