class BreedsController < ApplicationController
  def index
    @breeds = DogApiService.new.fetch_breeds
  end

  def show
    @breed = DogApiService.new.fetch_breed(params[:id])

    if @breed.nil?
      flash[:error] = "Breed not found"
      redirect_to breeds_path
    else
      @breed_images = DogApiService.new.fetch_breed_images(@breed["id"], 1)
    end
  end
end
