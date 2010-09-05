# encoding: utf-8

require "rubygems"
require "bundler/setup"
require "twitter"

module TranslateIt
  BASE_DIR = File.join(File.dirname(__FILE__), '..')
end

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")

require "translate_it/oauth"
require "translate_it/core"

# client = Twitter::Base.new(TranslateIt::OAuth.load)
# client.mentions.each { |tweet| puts "#{tweet.screen_name} => #{tweet.text}" }
