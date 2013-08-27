UIViewController.class_eval do

  attr_accessor :hud

  def loadHud
    @hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    @hud.mode = MBProgressHUDAnimationFade;
    @hud.labelText = I18n.t('hud_loading_msg')
  end

  def showHud
    @hud.show(true)
  end

  def hideHud
    MBProgressHUD.hideHUDForView(self.view, animated: true)
  end

  def createBackButton
    backBtn = UIButton.buttonWithType(UIButtonTypeCustom)
    backBtnBackgroundImage = UIImage.imageNamed('chevron-left.png')
    backBtn.frame = CGRectMake(0, 0, backBtnBackgroundImage.size.width, backBtnBackgroundImage.size.height)
    backBtn.setBackgroundImage(backBtnBackgroundImage, forState: UIControlStateNormal)
    backBtn.addTarget(self, action: 'popBack', forControlEvents: UIControlEventTouchUpInside)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(backBtn)
  end

  def popBack
    self.navigationController.popViewControllerAnimated(true)
  end

end