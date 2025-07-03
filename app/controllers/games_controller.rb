require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(',') # Convert back to array

    if !included_in_grid?(@word, @letters)
      @result = "❌ #{@word} can’t be built out of the given grid."
    elsif !english_word?(@word)
      @result = "❌ #{@word} is not a valid English word."
    else
      @result = "✅ Congratulations! #{@word} is valid!"
    end
  end

  private

  def included_in_grid?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  rescue
    false
  end
end
