class NewRepositoryController < UIViewController

  def initWithNibName(nibName, bundle:nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'New Repository'
    self.view.setBackgroundColor(UIColor.whiteColor)
  end

end