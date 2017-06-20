require 'google/api_client/client_secrets'
require 'sinatra'
require 'sinatra/json'
require 'pry'

class AuthorizationsController < ApplicationController

  get '/' do
    redirect to('/oauth2callback')
  end

  get '/oauth2callback' do
    #binding.pry
    client_secrets = Google::APIClient::ClientSecrets.load 'client_secret.json'
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
      binding.pry
      redirect to('/reservations')
    end
  end

end