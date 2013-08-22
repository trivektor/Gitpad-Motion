class NewsfeedCell < UITableViewCell

  attr_accessor :event

  def initialize
    @iconLabel = UILabel.alloc.initWithFrame(CGRectMake(20, 9, 20, 21))
    @titleLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 8, 916, 21))
    @descriptionLabel = UILabel.alloc.initWithFrame(CGRectMake(53, 28, 916, 21))

    @titleLabel.text = 'Title'
    @descriptionLabel.text = 'Description'

    @contentView.addSubview(@iconLabel)
    @contentView.addSubview(@titleLabel)
    @contentView.addSubview(@descriptionLabel)
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
    containerView = UIView.alloc.initWithFrame(self.view.bounds)
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.delegate = self
    @table.dataSource = self

    self.view.addSubview(containerView)
    containerView.addSubview(@table)
  end

  def tableView(tableView, numberOfRowsInSection: section)
    10
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier('NewsFeedCell')

    if !cell
      cell = NewsfeedCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'NewsFeedCell')
    end

    cell
  end

end