require "dotenv/load"
require "./youtube"
require "./slack"

youtube = YouTube.new(application_name: ENV["YOUTUBE_APPLICATION_NAME"])
statistics = youtube.channels_list_by_id("statistics", id: "UCOf_rlkZOLroqQugaWIKXFQ")

content = "```#{JSON.pretty_generate(statistics)}```"

slack = Slack.new(ENV["SLACK_WEBHOOK_URL"])
slack.post(content)
