require 'sinatra/json'
require 'json'
require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

# CalendarsController
class CalendarsController < ApplicationController

  before do
    check_for_credentials
    parse_client_options
    form_auth_client
    make_new_calendar_service
    authenticate_calendar_service
  end

  get '/calendars/new/:calendar_name' do
    calendar = Google::Apis::CalendarV3::Calendar.new(
        summary: params[:calendar_name],
        time_zone: 'America/Los_Angeles'
    )
    result = @calendar.insert_calendar(calendar)

  end

  get '/calendars/:calendar_name' do
    result = @calendar.get_calendar(params[:calendar_name])
    "<pre>#{JSON.pretty_generate(result.to_h)}</pre>"
  end
end