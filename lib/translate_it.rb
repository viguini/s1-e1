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
