
class CalendarsController < ApplicationController

  post '/calendars/new' do
    calendar = Google::Apis::CalendarV3::Calendar.new(
        summary: 'calendarSummary',
        time_zone: 'America/Los_Angeles'
    )
    result = client.insert_calendar(calendar)

  end
end