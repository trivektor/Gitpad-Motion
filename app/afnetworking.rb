module AFNetWorking

  def buildHttpClient(options={})
    @httpClient ||= AFMotion::Client.build_shared(options[:base_url] || GITHUB_API_HOST) do
      header "Accept", "application/json"
      authorization(options[:authorization]) if options[:authorization]
      parameter_encoding :json unless options[:parameter_encoding] === false
      operation :json
    end
  end

end