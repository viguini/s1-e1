# encoding: utf-8

module TranslateIt
  extend self
  
  def parse_tweet(text)
    options = {:from => "", :to => "english"}
    text.slice!('@translate_it')
    from = text.slice!(/from\s+(\w+)/)
    to   = text.slice!(/to\s+(\w+)/)
    options[:from] = from.slice(/from\s+(\w+)/, 1) if from
    options[:to]   = to.slice(/to\s+(\w+)/, 1) if to
    options[:q]    = text.squeeze(" ").strip
    options
  end
  
  def reply(tweet, client)
    translation = Google.translate(parse_tweet(tweet.text))
    msg = "@#{tweet.user.screen_name} #{translation}"
    client.update(msg, :in_reply_to_status_id => tweet.id)
  end
  
  def reply_last_mentions(client = Twitter::Base.new(TranslateIt::OAuth.load))
    client.mentions.each do |tweet|
      reply(tweet, client)
    end
  end
end
