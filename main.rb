require "dotenv/load"
require "fileutils"
require "./youtube"
require "./slack"

def handler(event:, context:)
  # credentials.yamlは認可の過程で更新される。lambdaでファイルを更新するときは、/tmp以下で行う。
  FileUtils.cp('youtube-quickstart-ruby-credentials.yaml', '/tmp/youtube-quickstart-ruby-credentials.yaml')
  youtube = YouTube.new(
      application_name: ENV["YOUTUBE_APPLICATION_NAME"],
      credentials_path: File.path('/tmp/youtube-quickstart-ruby-credentials.yaml')
  )
  statistics = youtube.channels_list_by_id("statistics", id: "UCOf_rlkZOLroqQugaWIKXFQ")
  FileUtils.rm('/tmp/youtube-quickstart-ruby-credentials.yaml')

  content = "```#{JSON.pretty_generate(statistics)}```"

  slack = Slack.new(ENV["SLACK_WEBHOOK_URL"])
  slack.post(content)
end
