class NewsfeedController < UIViewController

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    navigationItem.title = 'Newsfeed'
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    containerView = UIView.alloc.initWithFrame(self.view.bounds)
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
  end

end