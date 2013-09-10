class FileController < UIViewController

  attr_accessor :fileWebView, :themeOptions, :mimeType

  CSS_FILES = [
    'prettify',
    'desert',
    'sunburst',
    'son-of-obsidian',
    'doxy'
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
    @fileWebView = self.createWebView
    self.view.addSubview(@fileWebView)
  end

  def connection(connection, didReceiveResponse: response)
    @mimeType = response.MIMEType
  end

  def actionSheet(actionSheet, clickedButtonAtIndex: buttonIndex)
    unless @themeOptions.buttonTitleAtIndex(buttonIndex) == 'Cancel'
      @cssFile = CSS_FILES[buttonIndex]
      fetchRawFile
    end
  end

  def switchTheme
    @themeOptions = IBActionSheet.alloc

    @themeOptions.send(:'initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:',
      'Switch Theme',
      self,
      'Cancel',
      nil,
      'Default', 'Desert', 'Sunburst', 'Sons of Obsidian', 'Doxy', nil
    )

    @themeOptions.setFont(UIFont.fontWithName('Roboto-Light', size: 15))
    @themeOptions.setTitleFont(UIFont.fontWithName('Roboto-Bold', size: 17))
    @themeOptions.setTitleTextColor(UIColor.iOS7redColor)
    @themeOptions.showInView(self.navigationController.view)
    @themeOptions.rotateToCurrentOrientation
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
      bundle = NSBundle.mainBundle
      rawFilePath = bundle.pathForResource('html/raw_file', ofType: 'html')
      rawFileContent = NSString.stringWithContentsOfFile(rawFilePath, encoding: NSUTF8StringEncoding, error: nil)
      content = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)

      cssFile = bundle.pathForResource("html/prettify_themes/#{@cssFile || CSS_FILES.first}", ofType: 'css')

      htmlString = rawFileContent.stringByReplacingOccurrencesOfString('{{css_file}}', withString: cssFile)
                                 .stringByReplacingOccurrencesOfString('{{content}}', withString: encodeHtmlEntities(content))
      @fileWebView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle.bundlePath.nsurl)

      addThemeButton
      hideHud
    end
  end

end