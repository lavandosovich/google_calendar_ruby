require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'
require 'json'
require 'sinatra'

enable :sessions
set :session_secret, 'setme'

get '/' do
  unless session.has_key?(:credentials)
    redirect to('/oauth2callback')
  end
  client_opts = JSON.parse(session[:credentials])
  auth_client = Signet::OAuth2::Client.new(client_opts)
  calendar = Google::Apis::CalendarV3::CalendarService.new
  calendar.authorization = auth_client
  calendar_id = 'primary'
  files_1 = calendar.get_calendar(calendar_id)
  files   = calendar.list_events(calendar_id,
                               max_results: 10,
                               single_events: true,
                               order_by: 'startTime',
                               time_min: Time.now.iso8601)
  "<pre>#{JSON.pretty_generate(files_1.to_h)}</pre>"
end

get '/oauth2callback' do
  client_secrets = Google::APIClient::ClientSecrets.load 'web_client_secret.json'
  auth_client = client_secrets.to_authorization
  auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/calendar',
      :redirect_uri => url('/oauth2callback'))
  if request['code'] == nil
    auth_uri = auth_client.authorization_uri.to_s
    redirect to(auth_uri)
  else
    auth_client.code = request['code']
    auth_client.fetch_access_token!
    auth_client.client_secret = nil
    session[:credentials] = auth_client.to_json
    redirect to('/')
  end
end

