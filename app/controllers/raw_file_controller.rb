class RawFileController < UIViewController

  attr_accessor :fileWebView, :fileName, :mimeType, :rawFileRequest, :repo, :branch

  THEMES = [
    'prettify.css',
    'desert.css',
    'sunburst.css',
    'son-of-obsidian.css',
    'doxy.css'
  ]

  def initWithNibName(nibName, bundle:nibBundle)
    super
    @nodes = []
    self
  end

  def viewDidLoad
    super
    createBackButton
    performHousekeepingTasks
    fetchRawFile
  end

  def performHousekeepingTasks
    self.navigationItem.title = @fileName

    @fileWebView = UIWebView.alloc.initWithFrame(self.view.bounds)
    @fileWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    @fileWebView.delegate = self

    self.view.addSubview(@fileWebView)
  end

  def connection(connection, didReceiveResponse: response)
    @mimeType = response.MIMEType
  end

  def connection(connection, didReceiveData: data)
    image = UIImage.imageWithData(data)

    if image
      @fileWebView.loadRequest(@rawFileRequest)
    else
      rawFilePath = NSBundle.mainBundle.pathForResource('html/raw_file', ofType: 'html')
      rawFileContent = NSString.stringWithContentsOfFile(rawFilePath, encoding: NSUTF8StringEncoding, error: nil)
      content = NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)

      htmlString = rawFileContent.stringByReplacingOccurrencesOfString('{{theme}}', withString: THEMES.first)
                                 .stringByReplacingOccurrencesOfString('{{content}}', withString: encodeHtmlEntities(content))
      @fileWebView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle.bundlePath.nsurl)
    end
  end

  private

  def fetchRawFile
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

  def encodeHtmlEntities(rawString)
    rawString.stringByReplacingOccurrencesOfString('>', withString: '&#62;')
             .stringByReplacingOccurrencesOfString('<', withString: '&#60;')
  end


end