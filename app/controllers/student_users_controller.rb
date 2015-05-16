class StudentUsersController < ApplicationController
  before_action :signed_in, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  # GET /student_users/1
  # GET /student_users/1.json
  def show
    @student_user = StudentUser.find(params[:id])
    @user = @student_user.user
  end

  # links to students#view
  def view
    #TODO
    @student_user = StudentUser.find(params[:id])
    @student = Student.find(@student_user[:student_id])
    @student.view
    #get @student's random url?

  end


  # GET /student_users/new
  def new
    @student_user = StudentUser.new
    @user = @student_user.user

  end

  # GET /student_users/1/edit
  def edit
    @student_user = StudentUser.find(params[:id])

    @user = @student_user.user

  end

  # POST /student_users
  # POST /student_users.json
  def create
    @student_user = StudentUser.new(student_user_params)
    @user = @student_user.user
    find_existing_student
    if @student_user.save
      session[:user_id] = @user.id
      redirect_to @student_user
    else
      render action: 'new'
    end

  end

  # PATCH/PUT /student_users/1
  # PATCH/PUT /student_users/1.json
  def update
    logger.info "^^^^^^^^^^^^^ StudentUsersController: entering update method!!!"
    @student_user = StudentUser.find(params[:id])

    @user = @student_user.user
    @student_user.update(student_user_params)

    #TODO USER SIGN IN AGAIN!!!

    #Session.create(:email => params[:student_user][:user_attributes][:email], :password => params[:student_user][:user_attributes][:password], :role => 'StudentUser')

    if @student_user.save
      #session[:user_id] = @user.id
      redirect_to @student_user
    else
      render action: 'edit'
    end
  end

  def correct_user
    @student_user = StudentUser.find(params[:id])
    redirect_to(signin_url, notice:'Incorrect User') unless current_user==@student_user.user
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_user_params
    params.require(:student_user).permit(:name, :email, :password, :password_confirmation, user_attributes: [ :id, :email, :name, :password, :password_confirmation, :identifiable_id, :identifiable_type ])
  end

  def find_existing_student
    if Student.where(:email => params[:student_user][:user_attributes][:email]).first
      logger.info "$$$$$$$$$$$ StudentUsersController find_existing_student: found it!"
      @student = Student.where(:email => params[:student_user][:user_attributes][:email]).first
      @student_user.student = @student
      @student_user[:student_id] = @student[:id]
      @student[:student_user_id] = params[:id]
    end
  end
end

