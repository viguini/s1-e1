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

# TranslateIt.reply_last_mentions

# puts TranslateIt::Google.translate(:from => "portuguese", :to => "bravan", :q => "urso de pelúcia")

# mentions = YAML::load(open("#{TranslateIt::BASE_DIR}/test/fixtures/mentions"))[0..1]
# mentions.reverse.each {|m| puts m.text}
