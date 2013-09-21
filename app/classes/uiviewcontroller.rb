UIViewController.class_eval do

  attr_accessor :hud

  def loadHud
    @hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    @hud.mode = MBProgressHUDAnimationFade;
    @hud.labelText = 'Loading'
  end

  def showHud
    @hud.show(true)
  end

  def hideHud
    MBProgressHUD.hideHUDForView(self.view, animated: true)
  end

  def createBackButton
    return if self.navigationController.viewControllers.length == 1

    backBtn = UIButton.buttonWithType(UIButtonTypeCustom)
    backBtnBackgroundImage = UIImage.imageNamed('chevron-left.png')
    backBtn.frame = CGRectMake(0, 0, backBtnBackgroundImage.size.width, backBtnBackgroundImage.size.height)
    backBtn.setBackgroundImage(backBtnBackgroundImage, forState: UIControlStateNormal)
    backBtn.addTarget(self, action: 'popBack', forControlEvents: UIControlEventTouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(backBtn)
  end

  def popBack
    'CloseViewDeck'.post_notification
    self.navigationController.popViewControllerAnimated(true)
  end

  def createTable(options={})
    table = UITableView.alloc.initWithFrame(
      options[:frame] || self.view.bounds,
      style: options[:style] || UITableViewStylePlain
    )

    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    table.delegate = self
    table.dataSource = self

    if options[:scrollEnabled].nil?
      table.setScrollEnabled(true)
    else
      table.setScrollEnabled(options[:scrollEnabled])
    end

    unless options[:cell].nil?
      table.registerClass(options[:cell], forCellReuseIdentifier: options[:cell].reuseIdentifier)
    end

    table.backgroundView = nil
    table
  end

  def createWebView(options={})
    webView = UIWebView.alloc.initWithFrame(self.view.bounds)
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    webView.delegate = self
    webView
  end

  def encodeHtmlEntities(rawString)
    rawString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
             .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end

  def createFontAwesomeButton(options={})
    btn = UIBarButtonItem.titled(FontAwesome.icon(options[:icon])) do
      self.send(options[:touchHandler])
    end

    btn.setTitleTextAttributes({
      UITextAttributeFont => FontAwesome.fontWithSize(options[:size] || 20),
      UITextAttributeTextColor => (options[:color] || :black).uicolor
    }, forState: UIControlStateNormal)
  end

end