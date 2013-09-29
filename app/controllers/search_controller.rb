class SearchController < UIViewController

  attr_accessor :searchBar, :searchResults

  def viewDidLoad
    super
    @searchResults = []
    performHousekeepingTasks
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Search'
    buildSearchBar
    @table = createTable(frame: [[0, 44], [1024, 1024]])
    self.view.addSubview(@table)
  end

  def buildSearchBar
    @searchBar = UISearchBar.alloc.initWithFrame([[0, 0], [1024, 44]])
    @searchBar.setTintColor([220, 220, 220].uicolor)
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

    cell
  end

end