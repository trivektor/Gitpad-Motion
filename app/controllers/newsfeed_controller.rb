class NewsfeedCell < UITableViewCell

  attr_accessor :event

  def initialize
    @iconLabel = UILabel.alloc.initWithFrame(CGRectMake(20, 9, 20, 21))
    @titleLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 8, 916, 21))
    @descriptionLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 28, 916, 21))

    self.contentView.addSubview(@iconLabel)
    self.contentView.addSubview(@titleLabel)
    self.contentView.addSubview(@descriptionLabel)

    @titleLabel.text = 'Title'
    @descriptionLabel.text = 'Description'
  end

end

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
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self

    self.view.addSubview(@table)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    10
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @cellIdentifier ||= 'NewsFeedCell'
    cell = @table.dequeueReusableCellWithIdentifier(@cellIdentifier)

    if !cell
      cell = NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cellIdentifier)
    end

    cell
  end

end