class BreedsController < ApplicationController
  def index
    @breeds = DogApiService.new.fetch_breeds
  end

  def show
    @breed = DogApiService.new.fetch_breed(params[:id])

    if @breed.nil?
      flash[:error] = "Breed not found"
      redirect_to breeds_path
    end
  end
end
