require 'sinatra'

get '/' do
  make_video(params)
end

post '/' do
  make_video(params)
end

get '/view' do
  file = "final.mp4"
  send_file file, type: "video/mp4", disposition: 'inline'
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
