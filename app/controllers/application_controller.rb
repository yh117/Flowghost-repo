class ApplicationController < ActionController::Base

	# Include LTI context for accessing it in our views and actions
	include Omniauth::Lti::Context
	
	# Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user  
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def signed_in
	if current_user.nil?
		store_location
  	 	redirect_to signin_url, notice: "Please sign in."
	end
  end


  def verify_user_by_course
      #if course_id was not passed in, use id param
      params[:course_id]=params[:id] if params[:course_id].nil?

      @course = Course.find(params[:course_id])
      #finds the correct user associated with this course and compares it to the current user
      correct_user_id=@course.user_id
      redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
  end


  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end


  helper_method :current_user, :signed_in


end
