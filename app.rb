#!/usr/bin/env ruby

require 'bundler'
require 'nokogiri'
require 'open-uri'
require 'sinatra/base'
require 'sinatra/reloader'


APP_ROOT = File.dirname(__FILE__)

class Application < Sinatra::Base


	get '/' do
		haml :index
	end

    configure :development do
        register Sinatra::Reloader
    end 

	post '/' do
		url = params[:url] # such as 'http://asg.to/contentsPage.html?mcd=FSom9YGYbmiBT1yl'
		if !validateURL(url)
			@mes = 'invalid url'
			redirect '/'
		end

		USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A365 Safari/600.1.4'

		html = open(url, 'User-Agent' => USER_AGENT).read

		doc = Nokogiri::HTML.parse(html)

		# <video id="videoClip" type="video/mp4" src="${video_url}" width="0" height="0"></video>
		movie_url = doc.css('video#videoClip').attribute('src').to_s

		#`wget -O #{APP_ROOT}/outputs/ruby2.mp4 "#{movie_url}"`
		file_name = APP_ROOT + "/outputs/ruby2.mp4"
		send_file(file_name, :disposition => 'attachment', :filename => File.basename(file_name))

	end

	helpers do 
		def validateURL(url)
			return true
		end
	end

end

