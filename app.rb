require 'sinatra'
require "bugsnag"

class App < Sinatra::Base
  Bugsnag.configure do |config|
    config.api_key = ENV['BUGSNAG_API_KEY']
  end
end

  use Bugsnag::Rack
  enable :raise_errors

  get '/' do
    make_video(params)
  end

  get '/translate' do
    make_video(params)
    redirect to('/view')
  end

  post '/' do
    make_video(params)
  end

  get '/view' do
    # send_file "final.mp4", type: "video/mp4", disposition: 'inline'
    erb :index
  end

  get '/watch' do
    erb :index
  end

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end

  def make_video(params)
    words = params["words"] || ""
    scrub_words = words.gsub(/[^A-Za-z ]/, '')
    puts "words are #{scrub_words}"
    cmd = "./stitcher.sh '#{scrub_words}'"
    if !words.empty? && system("#{cmd}")
      "#{request.base_url}/view"
    else
      "Couldn't parse that"
    end
  end

  def return_video(params)
    words = params["words"] || ""
    scrub_words = words.gsub(/[^A-Za-z ]/, '')
    puts "words are #{scrub_words}"
    cmd = "./stitcher.sh '#{scrub_words}'"
    if !words.empty? && system("#{cmd}")
      send_file "final.mp4", type: "video/mp4", disposition: 'inline'
    else
      "Couldn't parse that"
    end
  end