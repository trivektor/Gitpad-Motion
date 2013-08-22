class MasterController < UIViewController

  attr_accessor :user

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    containerView = UIView.alloc.initWithFrame(self.view.bounds)
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
  end

end