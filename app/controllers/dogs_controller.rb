class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy, :like]

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = dogs_with_ads
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    # only a logged in user can like
    # You can't like your own doggie
    if user_signed_in? && @dog.try(:owner).try(:id) != current_user.id
      if current_user.liked? @dog
        @dog.unliked_by current_user
      else
        @dog.liked_by current_user
      end
    end
  end

  private
    def dogs_with_ads
      # We dont have many dogs so I can get away with this for now
      # But will prob need an order here with joins on the votes table to make a SQL statement
      dogs = Dog.all.sort_by{ |dog| [dog.updated_at < 1.hours.ago ? 0 : 1, -dog.get_likes.size] }.each_with_index.reduce([]) do |memo, (dog, i)|
        after_two = (i + 1) % 3
        if after_two == 0
          memo << "some sample ad here"
        else
          memo << dog
        end
      end

      dogs.paginate(page: params[:page], per_page: 5)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end
end
