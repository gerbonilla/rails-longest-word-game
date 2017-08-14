class GameController < ApplicationController

  def home
    random = []
    15.times { random << ("A".."Z").to_a.sample }
    @random_word = random.join(" ")
  end

  def score
    time = (params[:end_time].to_i - params[:start_time].to_i)
    grid = params[:grid]
    attempt = params[:answer]
    @result = produce_score(attempt, grid, time)
  end

  def startAgain
    cookies[:score] = 0
    redirect_to '/game'
  end

  private

  def produce_score(attempt, grid, time)
    attempts = attempt.upcase.split("")
    url = "https://wagon-dictionary.herokuapp.com/" + attempt.downcase
    if valid_in_grid?(attempts, grid)
      word_check = JSON.parse(open(url).read)
      result = { time: time, score: word_check["length"] * 99 / (time + 1), message: "Well Done" } if word_check["found"]
      result = { time: time, score: 0, message: "Not a Word" } unless word_check["found"]
    else result = { time: time, score: 0, message: "Try Again" }
    end
    cookies[:score] = cookies[:score].to_i + result[:score]
    return result
  end

  def valid_in_grid?(answer_characters, grid, result = true)
    attempt_h = {}
    answer_characters.each { |letter| attempt_h[letter].nil? ? attempt_h[letter] = 1 : attempt_h[letter] += 1 }
    grid_h = {}
    grid.split("").each { |letter| grid_h[letter].nil? ? grid_h[letter] = 1 : grid_h[letter] += 1 }
    attempt_h.each do |letter, count|
      if grid_h[letter].nil? then result = false
      elsif grid_h[letter] < count then result = false
      end
    end
    return result
  end

end
