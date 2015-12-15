class MechanicsController < ApplicationController
  def index
    respond_with Mechanic.all
  end
end