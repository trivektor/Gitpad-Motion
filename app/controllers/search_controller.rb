class SearchController < UIViewController

  attr_accessor :searchBar, :searchToggle, :searchResults

  TOGGLES = ['Repo', 'User']

  def viewDidLoad
    super
    @searchResults = []
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Search'
    createSearchBar
    createSearchToggle
    registerEvents
    @table = createTable(frame: [[0, 44], [1024, 1024]])
    self.view.addSubview(@table)
  end

  def registerEvents
    'SearchResults'.add_observer(self, 'displaySearchResults:')
  end

  def createSearchBar
    @searchBar = UISearchBar.alloc.initWithFrame([[0, 0], [1024, 44]])
    @searchBar.setTintColor([220, 220, 220].uicolor)
    @searchBar.delegate = self
    searchBarTextField = @searchBar.subviews.select { |v| v.is_a? UITextField }.first
    searchBarTextField.borderStyle = UITextBorderStyleNone
    searchBarTextField.backgroundColor = UIColor.whiteColor
    searchBarTextField.background = nil

    layer = searchBarTextField.layer
    layer.borderWidth = 1.0
    layer.borderColor = [178, 178, 178].uicolor
    layer.cornerRadius = 3.0
    layer.shadowOpacity = 0
    layer.masksToBounds = true
    self.view.addSubview(@searchBar)
  end

  def createSearchToggle
    @searchToggle = UISegmentedControl.alloc.initWithItems(TOGGLES)
    @searchToggle.segmentedControlStyle = UISegmentedControlStyleBar
    @searchToggle.momentary = false
    @searchToggle.selectedSegmentIndex = 0
    searchToggleBtn = UIBarButtonItem.alloc.initWithCustomView(@searchToggle)
    self.navigationItem.rightBarButtonItem = searchToggleBtn
  end

  def userSearch?
    @searchToggle.selectedSegmentIndex = 1
  end

  def repoSearch?
    @searchToggle.selectedSegmentIndex = 0
  end

  def searchBarSearchButtonClicked(searchBar)
    searchBar.resignFirstResponder
    term = @searchBar.text
    return unless term
    userSearch? ? Search.user(term) : Search.repo(term)
  end

  def displaySearchResults(notification)
    @searchResults = notification.object
    @table.reloadData
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @searchResults.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    result = @searchResults[indexPath.row]
    text = if result.is_a? Repo
      result.name
    elsif result.is_a? User
      result.login
    end

    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 13)
    cell.textLabel.text = text
    cell.defineAccessoryType
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    result = @searchResults[indexPath.row]

    if result.is_a? Repo
      controller = RepoController.alloc.init
      controller.repo = result
    elsif result.is_a? User
      controller = ProfileController.alloc.init
      controller.user = result
    end

    self.navigationController.pushViewController(controller, animated: true)
  end

end