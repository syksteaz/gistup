class GistsController < ApplicationController

  def callback
  end

  def index
    client = Octokit::Client.new(:client_id => Rails.application.secrets.CLIENT_ID,:client_secret => Rails.application.secrets.CLIENT_SECRET, :access_token => params[:access_token])
    @gists_result = client.gists
    gists_ids = []
    length = @gists_result.size-1
    (0..length).each do |number|
      gists_ids << @gists_result[number][:id]
    end
  end

  def show
    @gists_result = RestClient.get('https://api.github.com/gists/'+params[:id], { client_id: Rails.application.secrets.CLIENT_ID, client_secret: Rails.application.secrets.CLIENT_ID, access_token: params[:access_token] })
    @parsed_gists_result = JSON.parse(@gists_result)
  end

  def new
    @gist = Gist.new
  end

  def create
    @gist = Gist.new(gist_params)
    @gist.save
    gist = Gist.last
    client = Octokit::Client.new(:client_id => Rails.application.secrets.CLIENT_ID,:client_secret => Rails.application.secrets.CLIENT_SECRET, :access_token =>'09b59b1ad64a10c8ad25db61d086a520653f3140')
    client.create_gist(:description => gist.description, :public => gist.public, :files => {gist.name => {:content => gist.content}})
    gist.destroy
    redirect_to gists_path
  end

  def category_create
    params[:gist_ids].each do |id|
      existing_gist = Gist.find_by_github_gist_id(id)
      if existing_gist.nil?
        gist = Gist.create(github_gist_id: id, categories: [params[:category]])
      else
        existing_gist.categories.push(params[:category])
        existing_gist.save
      end
    end
    redirect_to gists_path
  end

  def search_for_category
    @result = params[:category]
    @hash_of_gists_for_display = {}
    @gistid = Gist.where('categories LIKE "%choco%"').pluck(:github_gist_id)
    @gistid.each do |gistid|
      intermediary_hash_of_gists = {}
      client = Octokit::Client.new(:client_id => Rails.application.secrets.CLIENT_ID,:client_secret => Rails.application.secrets.CLIENT_SECRET, :access_token => params[:access_token])
      gist_fetched = client.gist(gistid)
      intermediary_hash_of_gists[:filename] = gist_fetched[:"files"].first[0]
      intermediary_hash_of_gists[:description] = gist_fetched[:"files"].first[0]
      @hash_of_gists_for_display[gistid] = intermediary_hash_of_gists
    end
  end

end

private

  def gist_params
    params.require(:gist).permit(:name, :description, :content, :public)
  end
