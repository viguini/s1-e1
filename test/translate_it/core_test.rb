# encoding: utf-8

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../lib")
require "translate_it"

require "test/unit"
require "contest"

class CoreTest < Test::Unit::TestCase
  describe "tweet parsing" do
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
end