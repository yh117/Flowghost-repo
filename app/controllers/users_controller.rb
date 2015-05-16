class UsersController < ApplicationController
  #before_action :signed_in, only: [:show, :edit, :update]
  #before_action :correct_user, only: [:show, :edit, :update]

  #before_filter :load_identifiable

  #def load_identifiable
  #  klass = [Status, Medium].detect { |c| params["#{c.name.underscore}_id"] }
  #  @identifiable = klass.find(params["#{klass.name.underscore}_id"])
  #end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    #TODO SET USER HERE!!!!!!!!!
    @user = User.find(params[:id])

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.create(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update(:email => params[:user][:email], :name => params[:user][:name], :password=> params[:user][:password], :password_confirmation=> params[:user][:password_confirmation])
      if @user[:identifiable_type] == 'StudentUser'
	redirect_to StudentUser.find(@user[:identifiable_id])
      else
	redirect_to InstructorUser.find(@user[:identifiable_id])

      end
    else
      render action: 'edit'
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(signin_url, notice:'Incorrect User') unless current_user==@user
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email,:identifiable_type, :password, :password_confirmation)
  end

end
