# encoding: utf-8

module TranslateIt
  module OAuth
    extend self
    
    def load
      config = File.exists?("#{TranslateIt::BASE_DIR}/.twitter") ? YAML::load(open("#{TranslateIt::BASE_DIR}/.twitter")) : Hash.new
      if config.empty?
        print "> what was the comsumer key twitter provided you with? "
        config['token'] = gets.chomp
        print "> what was the comsumer secret twitter provided you with? "
        config['secret'] = gets.chomp
        File.open( "#{ENV['HOME']}/.twitter", 'w' ) do |out|
           YAML.dump( config, out )
        end
      end

      oauth = Twitter::OAuth.new(config['token'], config['secret'])
      if config['atoken'] and config['asecret']
        oauth.authorize_from_access(config['atoken'], config['asecret'])
      else
        puts rtoken = oauth.request_token.token
        puts rsecret = oauth.request_token.secret
        puts rurl = oauth.request_token.authorize_url
        puts "access the url above"
        print "> what was the PIN twitter provided you with? "
        pin = gets.chomp
        oauth.authorize_from_request(rtoken, rsecret, pin)
        config['atoken'] = oauth.access_token.token
        config['asecret'] = oauth.access_token.secret
        File.open( "#{TranslateIt::BASE_DIR}/.twitter", 'w' ) do |out|
           YAML.dump( config, out )
        end
      end
      oauth
    end
  end
end