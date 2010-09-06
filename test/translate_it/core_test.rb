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
  end
end
