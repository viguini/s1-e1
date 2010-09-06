# encoding: utf-8

require "rubygems"
require "bundler/setup"
require "twitter"
require "cgi"
require "open-uri"
require "json"

module TranslateIt
  BASE_DIR = File.join(File.dirname(__FILE__), '..')
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "translate_it/oauth"
require "translate_it/core"
require "translate_it/translator"

# client = Twitter::Base.new(TranslateIt::OAuth.load)
# client.mentions.each { |tweet| puts "#{tweet.user.screen_name} => #{tweet.text}" }
# File.open( "#{TranslateIt::BASE_DIR}/test/fixtures/mentions", 'w' ) do |out|
#    YAML.dump( client.mentions, out )
# end

# json = JSON.parse '{"responseData": {"translatedText":"teddy bear"}, "responseDetails": null, "responseStatus": 200}'
# puts json["responseData"]["translatedText"]

# puts TranslateIt::Google.translate(:from => "portuguese", :to => "bravan", :q => "urso de pelúcia")
