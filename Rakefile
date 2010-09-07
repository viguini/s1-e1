require "rubygems"
require "rake"
require "rake/testtask"

POLL_INTERVAL = 25

task :default => [:test]

desc "Run all tests"
Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = Dir["test/**/*_test.rb"]
  test.verbose = true
end

desc "Polls Twitter for new mentions and reply them"
task :poll do
  require File.join(File.expand_path(File.dirname(__FILE__)), "lib", "translate_it")
  
  client = Twitter::Base.new(TranslateIt::OAuth.load)
  since_id = client.user_timeline(:count => 1).first.in_reply_to_status_id
  loop do
    last_id = TranslateIt.reply_last_mentions(since_id, client)
    since_id = last_id if last_id
    sleep(POLL_INTERVAL)
  end
end
