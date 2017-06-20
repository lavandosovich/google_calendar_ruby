require 'sinatra'
require 'google/api_client/client_secrets'

configure { set :server, :puma }
configure { set :bind, '0.0.0.0'}

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, 'setme'
  set :bind, '0.0.0.0'

  def authenticate_calendar_service
    @calendar.authorization = @auth_client
  end

  def make_new_calendar_service
    @calendar = Google::Apis::CalendarV3::CalendarService.new
  end

  def form_auth_client
    @auth_client = Signet::OAuth2::Client.new(@client_opts)
  end

  def parse_client_options
    @client_opts = JSON.parse(session[:credentials])
  end

  def check_for_credentials
    redirect to('/oauth2callback') unless session.has_key?(:credentials)
  end

  def form_reservation calendar
    data = []
    calendar.items.each do |event|
      data << { start_date: event.start.date || event.start.date_time,
                summary: event.summary }
    end
    data
  end
end