class GamesController < ApplicationController
  def game
    @grid = GamesController.generate_grid(9).join(" ")
  end

  def score
    @attempt = params[:attempt].downcase
    @grid = params[:grid]
    word_is_in_the_grid = GamesController.word_is_in_the_grid?(@attempt, @grid)
    @translation = GamesController.get_from_api(@attempt)
    attempt_has_translation = GamesController.attempt_has_translation?(@attempt, @translation)
    @translation = nil if attempt_has_translation == false
    attempt_length = @attempt.length
    @score = GamesController.score(attempt_length, word_is_in_the_grid, attempt_has_translation)

  end

  def self.generate_grid(grid_size)
    # TODO: generate random grid of letters
    random = []
    grid_size.times { random << ('a'..'z').to_a.sample }
    return random
  end


  def self.word_is_in_the_grid?(attempt, grid)
    (attempt.downcase.split("") & grid.downcase.split("")) == attempt.downcase.split("")
  end

  def self.get_from_api(attempt)
    url = "https://api-platform.systran.net/translation/text/translate?" \
          "source=en&target=fr&key=34a5ef4f-b9ef-4bcc-b669-04b54410e92b" \
          "&input=" + attempt
    JSON.parse(open(url).read)["outputs"][0]["output"]
  end

  def self.attempt_has_translation?(attempt, translation)
    translation.downcase == attempt.downcase ? false : true
  end

  def self.score(length, word_is_in_the_grid, attempt_has_translation)
    if word_is_in_the_grid && attempt_has_translation
      [100 * length, 'well done']
    elsif word_is_in_the_grid == false
      [0, "not in the grid"]
    elsif attempt_has_translation == false
      [0, "not an english word"]
    end
  end

end
