class GistCell < UITableViewCell

  attr_accessor :gist, :nameLabel, :fontAwesomeLabel, :descriptionLabel, :createdAtLabel

  def initWithStyle(style, reuseIdentifier:identifier)
    super
    @gist = nil
    createLabels
    self
  end

  def render

    @nameLabel.text = "gist:#{@gist.id}"
    @descriptionLabel.text = @gist.description

    setFontAwesomeIcon
  end

  private

  def createLabels
    @fontAwesomeLabel = UILabel.alloc.initWithFrame([[12, 10], [26, 21]])
    @fontAwesomeLabel.font = FontAwesome.fontWithSize(15)
    @nameLabel = UILabel.alloc.initWithFrame([[40, 9], [445, 21]])
    @nameLabel.font = UIFont.fontWithName('Roboto-Bold', size: 13)
    @descriptionLabel = UILabel.alloc.initWithFrame([[40, 36], [738, 21]])
    @descriptionLabel.font = UIFont.fontWithName('Roboto-Light', size: 13)

    self.contentView.addSubview(@fontAwesomeLabel)
    self.contentView.addSubview(@nameLabel)
    self.contentView.addSubview(@descriptionLabel)
  end

  def setFontAwesomeIcon
    icon = @gist.public? ? 'code' : 'lock'
    @fontAwesomeLabel.text = FontAwesome.icon(icon)
  end

end

class GistsController < UIViewController

  attr_accessor :user, :page, :table

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @page = 1
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    createBackButton
    loadHud
    registerEvents
    fetchGistsForPage(@page)
  end

  def performHousekeepingTasks
    self.navigationItem.title = 'Gists'

    @table = createTable
    @table.registerClass(GistCell, forCellReuseIdentifier:GistCell.reuseIdentifier)

    self.view.addSubview(@table)
  end

  def registerEvents
    'GistsFetched'.add_observer(self, 'displayGists')
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @user.gists.count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    67
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = @table.dequeueReusableCellWithIdentifier(GistCell.reuseIdentifier) || begin
      GistCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: GistCell.reuseIdentifier)
    end

    cell.gist = @user.gists[indexPath.row]
    cell.render
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    gistController = GistController.alloc.init
    gistController.gist = @gists[indexPath.row]
    self.navigationController.pushViewController(gistController, animated: true)
  end

  def fetchGistsForPage(page)
    showHud
    @user.fetchPersonalGistsForPage(@page)
    @page += 1
  end

  def displayGists
    @table.reloadData
    hideHud
  end

end