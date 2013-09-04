module AFNetWorking

  def buildHttpClient
    @httpClient ||= AFMotion::Client.build_shared(GITHUB_API_HOST) do
      header "Accept", "application/json"
      parameter_encoding :json
      operation :json
    end
  end

end