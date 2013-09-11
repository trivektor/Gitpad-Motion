class LanguagesController < UIViewController

  attr_accessor :repo

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    registerEvents
    @repo.fetchLanguages
  end

  def performHousekeepingTasks
    self.navigationItem.title = "#{repo.name}'s languages"

    @table = createTable
    self.view.addSubview(@table)
  end

  def registerEvents
    'RepoLanguagesFetched'.add_observer(self, 'displayLanguages')
  end

  def numberOfSectionsInTableView
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @repo.languages.count
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('Cell') || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: 'Cell')
    end

    language = @repo.languages[indexPath.row]
    cell.textLabel.font = UIFont.fontWithName('Roboto-Bold', size: 15)
    cell.textLabel.text = "#{language[:name]} (#{language[:percentage]}%)"
    cell
  end

  def displayLanguages
    @table.reloadData
  end

end