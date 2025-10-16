class DogsController < ApplicationController
  before_action :set_dog, only: %i[show edit update destroy]

  def index
    @dogs = Dog.includes(:owner).order(:name)
  end

  def show
    # @dog is set by before_action
  end

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(dog_params)

    if @dog.save
      redirect_to @dog, notice: "Dog was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @dog is set by before_action
  end

  def update
    if @dog.update(dog_params)
      redirect_to @dog, notice: "Dog was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @dog.destroy
      redirect_to dogs_path, notice: "Dog was successfully deleted."
    else
      redirect_to dogs_path, alert: "Failed to delete dog."
    end
  end

  private

  def set_dog
    @dog = Dog.find(params[:id])
  end

  def dog_params
    params.require(:dog).permit(:name, :breed, :age, :weight, :owner_id)
  end
end
