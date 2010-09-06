# encoding: utf-8

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../lib")
require "translate_it"

require "test/unit"
require "contest"

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
  
  describe "#generate_translation_url" do
    describe "general" do
      setup do
        @result = TranslateIt.generate_translation_url(:from => "portuguese", :to => "english", :q => "urso de pelúcia")
      end
      
      test "builds the query" do
        assert_equal "urso de pelúcia", CGI.unescape(@result)[/q=([^&]+)/, 1]
      end
      
      test "escapes the params" do
        assert_no_match /pelúcia/, @result
        assert_no_match /\s/, @result
      end
    end
    
    describe "with no source language" do
      test "builds the language pairs" do
        @result = TranslateIt.generate_translation_url(:from => "", :to => "english", :q => "urso de pelúcia")
        assert_equal "|en", CGI.unescape(@result)[/langpair=([^&]+)/, 1]
      end
    end

    describe "with a source language" do
      test "builds the language pairs" do
        @result = TranslateIt.generate_translation_url(:from => "portuguese", :to => "english", :q => "urso de pelúcia")
        assert_equal "pt|en", CGI.unescape(@result)[/langpair=([^&]+)/, 1]
      end
    end
  end
end
