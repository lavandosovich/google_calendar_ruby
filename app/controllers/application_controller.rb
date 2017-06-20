require 'sinatra'
configure { set :server, :puma }
configure { set :bind, '0.0.0.0'}

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, 'setme'
  set :bind, '0.0.0.0'

  def form_reservation calendar
    data = []
    calendar.items.each do |event|
      data << { start_date: event.start.date || event.start.date_time,
                summary: event.summary }
    end
    data
  end
end