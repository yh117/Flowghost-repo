class InstructorUsersController < ApplicationController
  before_action :signed_in, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  # GET /instructor_users/1
  # GET /instructor_users/1.json
  def show
    @instructor_user = InstructorUser.find(params[:id]) #IMPORTANT!!!
    @user = @instructor_user.user #IMPORTANT!!!

  end

  # GET /instructor_users/new
  def new
    @instructor_user = InstructorUser.new
    @user = @instructor_user.user

  end

  # GET /instructor_users/1/edit
  def edit 
    @instructor_user = InstructorUser.find(params[:id])
    @user = @instructor_user.user
    session[:user_id] = @user[:id] #TODO EXPERIMENT

  end

  # POST /instructor_users
  # POST /instructor_users.json
  def create
    @instructor_user = InstructorUser.new(instructor_user_params) 
    @user = @instructor_user.user
    if @instructor_user.save
      session[:user_id] = @user.id
      redirect_to @instructor_user 

    else                    
      render action: 'new'          
    end                                 

  end

  # PATCH/PUT /instructor_users/1
  # PATCH/PUT /instructor_users/1.json
  def update
    @instructor_user = InstructorUser.find(params[:id])
    @user = @instructor_user.user
    session[:user_id] = @user[:id]

    if @instructor_user.update(instructor_user_params)
      #session[:user_id] = @user[:id]

      #logger.info "*************INSTRUCTOR USERS CONTROLLER: session[:user_id] is "+@user[:id].to_s
      redirect_to @instructor_user
    else
      render action: 'edit'
    end
  end

  def correct_user
    @instructor_user = InstructorUser.find(params[:id])
    redirect_to(signin_url, notice:'Incorrect User') unless current_user==@instructor_user.user
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def instructor_user_params
    params.require(:instructor_user).permit(:name, :email, :password, :password_confirmation, user_attributes: [ :id, :email, :name, :password, :password_confirmation, :identifiable_id, :identifiable_type ])
  end
end


