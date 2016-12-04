#!/usr/bin/env ruby

require 'bundler'
require 'nokogiri'
require 'open-uri'
require 'sinatra/base'
require 'sinatra/reloader'


APP_ROOT = File.dirname(__FILE__)

class Application < Sinatra::Base

  configure do
    USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X)' +
                 'AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A365 Safari/600.1.4'
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    haml :index
  end

  post '/' do
    url = params[:url] # e.g. 'http://asg.to/contentsPage.html?mcd=FSom9YGYbmiBT1yl'
    if !validateURL(url)
      @mes = 'invalid url'
      redirect '/'
    end

    html = open(url, 'User-Agent' => USER_AGENT).read

    # doc = Nokogiri::HTML.parse(html)
    # <video id="videoClip" type="video/mp4" src="${video_url}" width="0" height="0"></video>
    movie_url = html.match(/http:.+mp4/).to_s
    random = (0...15).map{ (65 + rand(26)).chr }.join
    file_name = APP_ROOT + "/outputs/" + random + ".mp4"

    `wget -O #{file_name} "#{movie_url}"`
    send_file(file_name,
              disposition: 'attachment',
              filename: File.basename(file_name))
  end

  # TODO: validate agesage url
  helpers do
    def validateURL(url)
      return true
    end
  end
end
