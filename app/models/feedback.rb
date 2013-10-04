class Feedback

  extend AFNetWorking

  def self.sendToServer(params={})
    puts params
    buildHttpClient(base_url: GITOS_HOST, parameter_encoding: false)
    AFMotion::Client.shared.post("feedback", params) do |result|
      if result.success?
        'FeedbackSucceed'.post_notification
      else
        puts result.error.localizedDescription
      end
    end
  end

end