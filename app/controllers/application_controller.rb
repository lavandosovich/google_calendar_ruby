require 'sinatra'
configure { set :server, :puma }

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, 'setme'

  def form_reservation calendar
    data = []
    calendar.items.each do |event|
      data << { start_date: event.start.date || event.start.date_time,
                summary: event.summary }
    end
    data
  end
end