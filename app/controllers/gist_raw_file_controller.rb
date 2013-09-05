class GistRawFileController < FileController

  attr_accessor :gistFile

  def initWithNibName(nibName, bundle: nibBundle)
    super
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    fetchRawFile
  end
  
  def performHousekeepingTasks
    super
    self.navigationItem.title = @gistFile.name
  end

  def fetchRawFile
    showHud
    @rawFileRequest = NSURLRequest.requestWithURL(@gistFile.rawUrl.nsurl)
    rawFileConnection = NSURLConnection.connectionWithRequest(@rawFileRequest, delegate: self)
    rawFileConnection.start
  end

end