# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "test_helper")

class CoreTest < Test::Unit::TestCase
  describe "#tweet parsing" do
    describe "with lanugage pair supplied" do
      setup do
        @result = TranslateIt.parse_tweet("@translate_it urso de pelúcia from portuguese to english")
      end

      test "extracts the from language" do
        assert_equal "portuguese", @result[:from]
      end
    
      test "extracts the to language" do
        assert_equal "english", @result[:to]
      end
    
      test "extracts the text query" do
        assert_equal "urso de pelúcia", @result[:q]
      end
    end
    
    describe "pulling default values" do
      setup do
        @result = TranslateIt.parse_tweet("@translate_it urso de pelúcia")
      end

      test "returns default from language" do
        assert_equal "", @result[:from]
      end
    
      test "returns default to language" do
        assert_equal "english", @result[:to]
      end
    
      test "extracts the text query" do
        assert_equal "urso de pelúcia", @result[:q]
      end
    end
  end
  
  describe "reply" do
    setup do |variable|
      @mention = YAML::load(open("#{TranslateIt::BASE_DIR}/test/fixtures/mentions")).first
      @client = flexmock("client", :update => true)
    end
    
    test "translate the tweet" do
      flexmock(TranslateIt::Google).should_receive(:translate).and_return("teddy bear").once
      TranslateIt.reply @mention, @client
    end
    
    test "replies the translation" do
      client = flexmock("client")
      client.should_receive(:update).with(
        Regexp.new(@mention.user.screen_name), {:in_reply_to_status_id => @mention.id}).once
      TranslateIt.reply @mention, client
    end
    
    describe "on duplicate exceptions" do
      setup do
        @client = flexmock("client")
        @client.should_receive(:update).and_raise(Twitter::General.new("data"), "(403): Forbidden - Status is a duplicate.").once
      end
      
      test "rescue the exception and retries" do
        @client.should_receive(:update).and_return(true).once
        assert_nothing_raised do
          TranslateIt.reply @mention, @client
        end
      end

      test "replies with a message about the duplicate query" do
        @client.should_receive(:update).with(
          Regexp.new("already tried"), {:in_reply_to_status_id => @mention.id}).once
        TranslateIt.reply @mention, @client
      end
    end
  end
  
  describe "reply last mentions" do
    describe "with new mentions" do
      setup do
        @client = flexmock("client")
        @mentions = YAML::load(open("#{TranslateIt::BASE_DIR}/test/fixtures/mentions"))[0..1]
        @client.should_receive(:mentions).with(:since_id => @mentions.last.id).and_return(@mentions).once
        @client.should_receive(:update).with(
          Regexp.new("metal"), {:in_reply_to_status_id => @mentions[-1].id}).once
        @client.should_receive(:update).with(
          Regexp.new("bear"), {:in_reply_to_status_id => @mentions[-2].id}).once
      end
    
      test "starts from the provided id" do
        TranslateIt.reply_last_mentions(@mentions.last.id, @client)
      end
    
      test "returns the id of the last replied tweet" do
        assert_equal @mentions.first.id, TranslateIt.reply_last_mentions(@mentions.last.id, @client)
      end
    end
    
    describe "without new mentions" do
      test "returns since_id" do
        client = flexmock("client")
        mentions = []
        since_id = 17
        client.should_receive(:mentions).with(:since_id => since_id).and_return(mentions).once
      
        assert_equal since_id, TranslateIt.reply_last_mentions(since_id, client)
      end
    end
  end
end
