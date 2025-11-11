class BreedsController < ApplicationController
  def index
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || 20
    # Limit per_page to reasonable values
    per_page = [per_page, 5].max    # minimum 5
    per_page = [per_page, 100].min  # maximum 100

    result = DogApiService.new.fetch_breeds(page: page, per_page: per_page)

    @breeds = result[:breeds]
    @current_page = result[:current_page]
    @total_pages = result[:total_pages]
    @total_count = result[:total_count]
    @per_page = result[:per_page]
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
