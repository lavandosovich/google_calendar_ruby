require 'sinatra/json'
require 'json'
require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

# ReservationController
class ReservationsController < ApplicationController

  before do
    check_for_credentials
    parse_client_options
    form_auth_client
    make_new_calendar_service
    authenticate_calendar_service
  end

  get '/reservations' do
    calendar_id = 'primary'
    files = @calendar.list_events(calendar_id,
                                 max_results: 10,
                                 single_events: true,
                                 order_by: 'startTime',
                                 time_min: Time.now.iso8601)
    data = form_reservation files

    "<pre>#{JSON.pretty_generate(data)}</pre>"
  end

  get '/reservations/new' do
    calendar_id = 'primary'
    event_hash = {summary: 'SUPER-DUPER MEET UP',
                  start: {
                      date_time: '2017-06-28T09:00:00-07:00',
                      time_zone: 'America/Los_Angeles'
                  },
                  end: {
                      date_time: '2017-06-28T17:00:00-07:00',
                      time_zone: 'America/Los_Angeles'
                  }
    }
    event = Google::Apis::CalendarV3::Event.new event_hash
    @calendar.insert_event(calendar_id, event)
  end

end