require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
    return @letters
  end

  def score
    @letters = params[:input].scan(/\w/)
    @word = params[:word].upcase
    if !word_check(parse_page)
      @message = "Sorry, but #{@word} does not seem to be a valid English word..."
    elsif word_check(parse_page) && !inc_word(@word, @letters)
      @message = "Sorry but #{@word} can't be built out of #{@letters}"
    elsif word_check(parse_page) && inc_word(@word, @letters)
      @message = "Congratulations! #{@word} is a valid English word!"
    end
  end

  def parse_page
    page_text = open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    parsed_page = JSON.parse(page_text)
    return parsed_page
  end

  def word_check(parsed_page)
    parsed_page['found'] == true
  end

  def inc_word(attempt, letters)
    attemptarr = attempt.split(//)
    (attemptarr - letters).empty?
  end
end
