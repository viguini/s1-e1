# encoding: utf-8

module TranslateIt
  extend self
  
  def parse_tweet(tweet)
    tweet.slice!('@translate_it')
    output = {}
    output[:from] = tweet.slice!(/from\s+(\w+)/).slice!(/from\s+(\w+)/).slice(/from\s+(\w+)/, 1)
    output[:to] = tweet.slice!(/to\s+(\w+)/).slice(/to\s+(\w+)/, 1)
    output[:q] = tweet.squeeze(" ").strip
    output
  end
end
