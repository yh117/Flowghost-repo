class AssignmentsController < ApplicationController

  # before_action :verify_user_by_course, only: [:new, :destroy]
  before_filter :verify_user_by_course, only: [:create]
  before_action :check_ownership, only: [:destroy]


  def show
    @assignment = Assignment.find(params[:id],params[:course_id],params[current_user]) #TODO WHY DO I HAVE TO REPEAT THIS EVERY TIME??????????
  end



  # GET /assignments
  # GET /assignments.json
  def index
    #@assignments = Assignment.where(course_id: :course_id) #THIS DOESN'T WORK: NO COURSE SHOWS UP because (look at the logs) course_id is not a number; its passed as a parameter
    @assignments = Assignment.where(:course_id => params[:course_id]) #THIS WORKS
  end

  def create
    puts params
    #render @assignment.id #TODO ORIGINAL
    #render :json => { :id => @assignment.id } #TODO ORIGINAL
    @course = Course.find(params[:course_id])
    #@assignment = @course.assignments.create(assignment_params)
    @assignment = @course.assignments.create(:course_id => params[:course_id],:name => params[:assignment][:name], :points_possible => params[:assignment][:points_possible], :tagnames => tagnames_pre_process)

    if @assignment.save
      logger.info "************* Assignments Controller: new assignment is saved!!!!!!!!!!!!!1"
      redirect_to assignments_url(:course_id => params[:course_id]) #assignments index page
    else
      logger.info "************ Assignment Controller: new assignment NOT SAVED!!!!!!!!!!!!!"
      render action: 'new'
    end

  end

  def update
    @course = Course.find(params[:course_id])
    @assignment = Assignment.find(params[:id])
    if @assignment.update(:course_id => params[:course_id],:name => params[:assignment][:name], :points_possible => params[:assignment][:points_possible], :tagnames => tagnames_pre_process)
      redirect_to assignments_url(:course_id =>params[:course_id])
    else
      render action: 'edit'
    end
  end

  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find(params[:id],params[current_user]) #TODO WHY DO I HAVE TO REPEAT THIS EVERY TIME??????????

  end

  def destroy
    if Assignment.destroy(params[:id])
      redirect_to assignments_url(:course_id => params[:course_id])
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:course_id, :name, :points_possible, :tagnames)
    tagnames_pre_process
  end

  def check_ownership
    @course = Course.find(Assignment.find(params[:id]).course_id)
    #finds the correct user associated with this course and compares it to the current user
    correct_user_id=@course.user_id
    redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
  end

  # trim off extra ','
  def tagnames_pre_process
    tags_before = params[:tag][:tagnames]
    tags_after = ""
    beginning = 1
    tags_before.split("").each do |thisChar|
      if (thisItem!=' ' || thisItem!=',') 
	tags_after = tags_after + thisChar
	beginning == 0
      else #is ','
	if (beginning == 0)
	  tags_after == tags_after + thisChar
	end
      end
    end
    params[:tag][:tagnames]=tags_after
    return tags_after
  end



end
