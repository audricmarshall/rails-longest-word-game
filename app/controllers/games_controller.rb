# frozen_string_literal: true

require 'open-uri'
require 'json'

# Missin top level documentation error, donc voila le controller
class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample } # genere 10 lettres aléatoire
  end

  def score
    @letters = params[:letters].split # On récup la grille
    @word = params[:word].upcase # On récup le mot proposé

    # 1. Le mot ne peut pas être créé à partir de la grille
    if !word_in_grid?(@word, @letters)
      @result = "Sorry, but <strong>#{@word}</strong> can't be built out of #{@letters.join(', ')}"
    else
      # 2. Le mot est valide d’après la grille, mais ce n’est pas un mot anglais valide.
      # 3. Le mot est valide d’après la grille et est un mot anglais valide.
      response = URI.open("https://dictionary.lewagon.com/#{@word.downcase}") # vérifie le mot anglais via l'API
      json = JSON.parse(response.read)
      @result = if json['found']
                  # Le mot est valide d’après la grille et est un mot anglais valide.
                  "Congratulations! <strong>#{@word}</strong> is a valid English word!"
                  # Le mot est valide d’après la grille, mais ce n’est pas un mot anglais valide.
                else
                  "Sorry, but <strong>#{@word}</strong> is not a valid English word."
                end
    end
  end

  # Désolé pour l'indentation pourrie plus haut

  # je mets la verif dans une méthode privée à part car c'est juste un ch eck interne comme on l'avait vu en Ruby,
  # c'est + lisible, je la met que dans ce controller, pas besoin qu'elle soit accessible ailleurs

  private

  def word_in_grid?(word, grid)
    # je vérifie que chaque lettre du mot est dispo dans la grille autant de fois qu'il faut
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
