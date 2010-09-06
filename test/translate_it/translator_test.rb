# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "test_helper")

class TranslatorTest < Test::Unit::TestCase
  
  describe "#generate_translation_url" do
    describe "general" do
      setup do
        @result = TranslateIt::Google.generate_translation_url(:from => "portuguese", :to => "english", :q => "urso de pelúcia")
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
        @result = TranslateIt::Google.generate_translation_url(:from => "", :to => "english", :q => "urso de pelúcia")
        assert_equal "|en", CGI.unescape(@result)[/langpair=([^&]+)/, 1]
      end
    end

    describe "with a source language" do
      test "builds the language pairs" do
        @result = TranslateIt::Google.generate_translation_url(:from => "portuguese", :to => "english", :q => "urso de pelúcia")
        assert_equal "pt|en", CGI.unescape(@result)[/langpair=([^&]+)/, 1]
      end
    end
  end
  
  describe "#parse_response" do
    describe "status 200" do
      test "extracts the translated text" do
        options = {:from => "portuguese", :to => "english", :q => "urso de pelúcia"}
        response = '{"responseData": {"translatedText":"teddy bear"}, "responseDetails": null, "responseStatus": 200}'
        assert_equal "teddy bear (en) [urso de pelúcia - pt]", TranslateIt::Google.parse_response(response, options)
      end
      
      test "extracts the from language from the response" do
        options = {:from => "", :to => "english", :q => "urso de pelúcia"}
        response = '{"responseData": {"translatedText":"teddy bear","detectedSourceLanguage":"pt"}, "responseDetails": null, "responseStatus": 200}'
        assert_equal "teddy bear (en) [urso de pelúcia - pt]", TranslateIt::Google.parse_response(response, options)
      end
    end
    
    describe "status greater than 200" do
      test "points to the documentation" do
        options = {:from => "portuguese", :to => "wrong_language", :q => "urso de pelúcia"}
        response = '{"responseData": null, "responseDetails": "invalid translation language pair", "responseStatus": 400}'
        assert_match /http:\/\/translate-it.heroku.com/, TranslateIt::Google.parse_response(response, options)
      end
      
      test "show the error details" do
        options = {:from => "portuguese", :to => "wrong_language", :q => "urso de pelúcia"}
        response = '{"responseData": null, "responseDetails": "invalid translation language pair", "responseStatus": 400}'
        assert_match /invalid translation language pair/, TranslateIt::Google.parse_response(response, options)
      end
    end
  end
  
  describe "#translate" do
    setup do
      @options = {:from => "portuguese", :to => "english", :q => "urso de pelúcia"}
      url = TranslateIt::Google.generate_translation_url(@options)
      open_uri_options = {"User-Agent" => "Ruby/#{RUBY_VERSION}", "Referer" => "http://translate-it.heroku.com"}
      response = '{"responseData": {"translatedText":"teddy bear"}, "responseDetails": null, "responseStatus": 200}'
      result = StringIO.new(response, 'r')
      flexmock(TranslateIt::Google).should_receive(:open).with(url, open_uri_options).and_return(result).once
    end
    
    test "requests the translation" do
      assert_equal "teddy bear (en) [urso de pelúcia - pt]", TranslateIt::Google.translate(@options)
    end
  end
end