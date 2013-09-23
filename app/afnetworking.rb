module AFNetWorking

  def buildHttpClient(options={})
    @httpClient ||= AFMotion::Client.build_shared(GITHUB_API_HOST) do
      header "Accept", "application/json"
      authorization(options[:authorization]) if options[:authorization]
      parameter_encoding :json
      operation :json
    end
  end

end