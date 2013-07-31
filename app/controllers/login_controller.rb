class LoginController < UIViewController

  def viewDidLoad
    super
    navigationItem.title = 'Login'
    performHouseKeepingTasks
  end

  def performHouseKeepingTasks
    @loginTable = UITableView.alloc.initWithFrame(view.bounds)
    @loginTable.delegate = self
    view.addSubview @loginTable
  end



end