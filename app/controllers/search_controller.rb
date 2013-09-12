class SearchController < UIViewController

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Search'

    view = UIView.alloc.initWithFrame(self.view.bounds)
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    view.setBackgroundColor(UIColor.whiteColor)

    self.view.addSubview(view)
  end

end