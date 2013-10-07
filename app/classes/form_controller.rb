module Formotion
  class FormController < UITableViewController

    def createBackButton
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

  end
end