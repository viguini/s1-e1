# encoding: utf-8

module TranslateIt
  extend self
    
  def parse_tweet(tweet)
    options = {:from => "", :to => "english"}
    tweet.slice!('@translate_it')
    from = tweet.slice!(/from\s+(\w+)/)
    to   = tweet.slice!(/to\s+(\w+)/)
    options[:from] = from.slice(/from\s+(\w+)/, 1) if from
    options[:to]   = to.slice(/to\s+(\w+)/, 1) if to
    options[:q]    = tweet.squeeze(" ").strip
    options
  end
  
  def translate(options)
  end
end
