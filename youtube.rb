require "google/apis"
require "google/apis/youtube_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require "json"

class YouTube
  def initialize(
    redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
    application_name: "YouTube Data API Ruby Tests",
    client_secrets_path: "client_secret.json",
    credentials_path: File.join(Dir.home, ".credentials", "youtube-quickstart-ruby-credentials.yaml"),
    scope: Google::Apis::YoutubeV3::AUTH_YOUTUBE_READONLY
  )
    @redirect_uri = redirect_uri
    @client_secrets_path = client_secrets_path
    @credentials_path = credentials_path
    @scope = scope

    @service = Google::Apis::YoutubeV3::YouTubeService.new
    @service.client_options.application_name = application_name
    @service.authorization = authorize
  end

  def authorize
    FileUtils.mkdir_p(File.dirname(@credentials_path))

    client_id = Google::Auth::ClientId.from_file(@client_secrets_path)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: @credentials_path)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, @scope, token_store)
    user_id = "default"
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: @redirect_uri)
      puts "Open the following URL in the browser and enter the " +
          "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: @redirect_uri)
    end
    credentials
  end

  def channels_list_by_id(part, **params)
    response = @service.list_channels(part, params).to_json
    item = JSON.parse(response).fetch("items")[0]
    item.fetch("statistics")
  end
end