class GenresController < ApplicationController
  def index
    respond_with Genre.all
  end
end