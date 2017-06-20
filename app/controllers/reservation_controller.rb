require 'sinatra/json'
require 'json'
require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

# ReservationController
class ReservationsController < ApplicationController

  get '/reservations' do
    unless session.has_key?(:credentials)
      redirect to('/oauth2callback')
    end
    client_opts = JSON.parse(session[:credentials])
    auth_client = Signet::OAuth2::Client.new(client_opts)
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = auth_client
    calendar_id = 'primary'
    files = calendar.list_events(calendar_id,
                                 max_results: 10,
                                 single_events: true,
                                 order_by: 'startTime',
                                 time_min: Time.now.iso8601)
    data = form_reservation files

    "<pre>#{JSON.pretty_generate(data)}</pre>"
  end

end