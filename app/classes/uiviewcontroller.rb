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

end