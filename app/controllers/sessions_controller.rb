class SessionsController < ApplicationController

  # POST /sessions
  # POST /sessions.json
  def create
    user = User.find_by_email(params[:email])  

    if user.identifiable_type == params[:role] #TODO ?????

      if user && user.authenticate(params[:password]) 
	session[:user_id] = user.id  
	redirect_back_or root_url
      else  
	flash[:notice]="Invalid name or password"
	redirect_to :action=>"new"
      end
    else 
      flash[:notice]="You selected the wrong role"
      redirect_to :action=>"new"
    end
  end


  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    session[:user_id] = nil  
    redirect_to root_url 
  end

end
