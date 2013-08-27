class NewsfeedDetailsController < UIViewController

  attr_accessor :event

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    self.navigationItem.title = 'Details'
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    @wview = UIWebView.alloc.initWithFrame(self.view.bounds)
    @wview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    self.view.addSubview(@wview)
  end

end