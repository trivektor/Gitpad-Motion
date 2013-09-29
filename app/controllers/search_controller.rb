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