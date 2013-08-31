class GistCell < UITableViewCell

  attr_accessor :gist, :nameLabel, :fontAwesomeLabel, :descriptionLabel, :createdAtLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    @gist = nil
    createLabels
    self
  end

  def render
    @nameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 13)
    @nameLabel.text = @gist.id
    @descriptionLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)
    @descriptionLabel.text = @gist.description
  end

  private

  def createLabels
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[12, 10], [30, 21]])
    @nameLabel = UILabel.alloc.initWithFrame([[50, 9], [445, 21]])
    @descriptionLabel = UILabel.alloc.initWithFrame([[50, 36], [738, 21]])

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@nameLabel)
    self.contentView.addSubview(@descriptionLabel)
  end

end

class GistsController < UIViewController

  attr_accessor :user, :gists, :page, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
    @gists = []
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    registerEvents
    fetchGistsForPage(@page)
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Gists'

    @table = UITableView.alloc.initWithFrame(self.view.bounds, style:UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @table.delegate = self
    @table.dataSource = self
    @table.scrollEnabled = true
    @table.registerClass(GistCell, forCellReuseIdentifier:GistCell.reuseIdentifier)

    self.view.addSubview(@table)
  end

  def registerEvents
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'displayGists:', name: 'GistsFetched', object: nil)
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @gists.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(GistCell.reuseIdentifier)

    if !cell
      cell = GistCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:GistCell.reuseIdentifier)
    end

    cell.gist = @gists[indexPath.row]
    cell.render
    cell
  end

  def fetchGistsForPage(page)
    @user.fetchPersonalGistsForPage(@page)
    @page += 1
  end

  def displayGists(notification)
    @gists += notification.object
    @table.reloadData
  end

end