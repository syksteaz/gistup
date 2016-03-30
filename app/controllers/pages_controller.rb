class PagesController < ApplicationController
  require 'json'

  def home
    @client_id = Rails.application.secrets.CLIENT_ID
  end

  def callback
    result = RestClient.post('https://github.com/login/oauth/access_token', {client_id: Rails.application.secrets.CLIENT_ID, client_secret: Rails.application.secrets.CLIENT_SECRET, code: params[:code]})
    intermediary_result = JSON.parse(Hash.from_xml(result).to_json)
    @final_result = intermediary_result["OAuth"]["access_token"]
    redirect_to gists_path(access_token: @final_result)
  end

end
