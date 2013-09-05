class RawFileController < FileController

  attr_accessor :fileName, :rawFileRequest, :repo, :branch

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @nodes = []
    self
  end

  def viewDidLoad
    super
    performHousekeepingTasks
    fetchRawFile
  end

  def performHousekeepingTasks
    super
    self.navigationItem.title = @fileName
  end

  private

  def fetchRawFile
    showHud

    blobPaths = []

    self.navigationController.viewControllers.each do |controller|
      if controller.is_a? RepoTreeController
          blobPaths << controller.node.path unless controller.node.nil?
      end
    end

    paths = []
    paths << @repo.fullName unless @repo.nil?
    paths << @branch.name unless @branch.nil?
    paths << blobPaths.join('/') unless blobPaths.empty?
    paths << @fileName

    @rawFileRequest = NSURLRequest.requestWithURL("#{RAW_GITHUB_HOST}/#{paths.join('/')}".nsurl)
    rawFileConnection = NSURLConnection.connectionWithRequest(@rawFileRequest, delegate: self)
    rawFileConnection.start
  end

end