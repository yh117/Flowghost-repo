class TagsController < ApplicationController
  before_action :verify_user_by_course, only: [:create]
  before_action :check_ownership, only: [:destroy]


  def show
    @tag = Tag.find(params[:id],params[current_user]) #TODO WHY DO I HAVE TO REPEAT THIS EVERY TIME??????????
    #@assignments = Assignment.where(params[:course_id])
  end

  # GET /tags
  # GET /tags.json
  def index
    #@tags = Tag.where(course_id: :course_id) #THIS DOESN'T WORK: NO COURSE SHOWS UP because (look at the logs) course_id is not a number; its passed as a parameter
    @tags = Tag.where(:course_id => params[:course_id]) #THIS WORKS
  end

  def create
    @course = Course.find(params[:course_id])
    @assignments = Assignment.where(:course_id => params[:course_id])
    @tag = @course.tags.create(:course_id => params[:course_id], :name => params[:tag][:name], :assignmentnames => array_pre_process)
    @assignments.each do |thisAssignment|
      #if @tag.assignmentnames has the name of this assignment
      assignment_names_array = params[:tag][:assignmentnames].split(",")
      #assignment_names_array = params[:tag][:assignmentnames]
      assignment_names_array.each do |this_musthave_assignment|
	if (this_musthave_assignment == thisAssignment.name)
	  if thisAssignment.tagnames == ""
	    thisAssignment.update(:tagnames => (thisAssignment.tagnames + @tag.name))
	  else
	    thisAssignment.update(:tagnames => (thisAssignment.tagnames + ","+ @tag.name))
	  end

	  logger.info "%%%%%%%%%%%%%%% Tags controller create: updated thisAssignment's tagnames to "+thisAssignment.tagnames+@tag.name

	end
      end
    end
    if @tag.save
      redirect_to tags_url(:course_id => params[:course_id]) #courses#show page
    else
      render action: 'new'
    end
  end

  def update
    @course = Course.find(params[:course_id])
    @assignments = Assignment.where(:course_id => params[:course_id])
    @tag = Tag.find(params[:id])
    @tag.update(:course_id => params[:course_id], :name => params[:tag][:name], :assignmentnames => array_pre_process)
    logger.info "%%%%%%%%%%%%%%%%%%%%% UPDATE CALLED ON TAG "+params[:tag][:name]
    @assignments.each do |thisAssignment|
      #if @tag.assignmentnames has the name of this assignment
      assignment_names_array = params[:tag][:assignmentnames].split(",")
      if (!thisAssignment.tagnames.nil?)
	tag_names_array = thisAssignment.tagnames.split(",")
      else
	tag_names_array = Array.new
      end

      if assignment_names_array.include?(thisAssignment.name) #if this tag's assignments include thisAssignment
	if thisAssignment.tagnames.nil?
	  thisAssignment.tagnames = ""
	  console.log "WARNING!!!!!!!!!!! THISASSIGNMENT.TAGNAMES IS SET TO EMPTY"
	end
	# append new tag name 
	if (!tag_names_array.include?(@tag.name))
	  logger.info "!!!!!!!!! tags controller tagnames: tag_names_array does not include @tag.name, therefore its added to tagnames"
	  if thisAssignment.tagnames==""
	    thisAssignment.update(:tagnames => (thisAssignment.tagnames + @tag.name))
	    logger.info "$$$$$$$$$$$$$$ thisAssignment UPDATE CALLED!!!! thisAssignment.tagnames is now "+thisAssignment.tagnames
	  else
	    thisAssignment.update(:tagnames => (thisAssignment.tagnames + ","+ @tag.name))
	  end
	end

      elsif tag_names_array.size>0 #if the assignment's tags should not have @tag
	# delete the tag name from tagnames
	#tag_names_array = thisAssignment.tagnames.split(",")
	if tag_names_array.include?(@tag.name)
	  tag_names_array.delete(@tag.name)
	  logger.info "WARNING!!!!!!!!!!!!! tag is deleted from tagnames of assignment "
	  thisAssignment.update(:tagnames => tag_names_array.join(","))

	end
	#thisAssignment.update(:tagnames => tag_names_array.join(","))
      end

      deleteExtraTags = 0
      # just in case: check for all the tags and see if they still exist; it they dont, delete it
      tag_names_array.each do |checkThisTag|
	if (!Tag.where(:name => checkThisTag).present?) || (!Tag.exists?(:name => checkThisTag))
	  tag_names_array.delete(checkThisTag)
	  deleteExtraTags = 1
	end
      end
      if (deleteExtraTags == 1)
	thisAssignment.update(:tagnames => tag_names_array.join(","))
      end
    end

    if @tag.save
      redirect_to tags_url(:course_id => params[:course_id]) #courses#show page
    else
      render action: 'edit'
    end

  end


  def new
    @tag = Tag.new
    @assignments = Assignment.where(:course_id => params[:course_id])
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id], params[current_user]) #TODO WHY DO I HAVE TO REPEAT THIS EVERY TIME??????????
    @assignments = Assignment.where(:course_id => params[:course_id])
  end

  def destroy
    @tag = Tag.find(params[:id], params[current_user])
    @assignments = Assignment.where(:course_id => params[:course_id])
    #update assignment's tagnames
    @assignments.each do |thisAssignment|
      #if @tag.assignmentnames has the name of this assignment, remove @tag.name from thisAssignment.tagnames
      assignment_names_array = @tag.assignmentnames.split(",")
      if (assignment_names_array.include?(thisAssignment.name)) 
	#update thisAssignment.tagnames
	tag_names_array = thisAssignment.tagnames.split(",")
	tag_names_array.delete(@tag.name)
	thisAssignment.update(:tagnames => tag_names_array.join(","))
      end
    end

    if Tag.destroy(params[:id])
      redirect_to tags_url(:course_id => params[:course_id])
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:course_id, :name, :assignmentnames)
    array_pre_process
  end

  # turn array into a string and trim off empty items
  def array_pre_process
    array_before = params[:tag][:assignmentnames]
    string_after = ""
    beginning = 1
    array_before.each do |thisItem|
      if thisItem!=""
	if string_after!=""
	  string_after = string_after + ","+  thisItem
	else 
	  string_after = string_after+thisItem
	  #if (beginning==1)
	  #	string_after = string_after +  thisItem
	  #	beginning = 0
	  #else 
	  #	string_after = string_after + "," + thisItem
	end
      end
    end
    params[:tag][:assignmentnames]=string_after
    return string_after
  end

  def check_ownership
    @course = Course.find(Tag.find(params[:id]).course_id)
    #finds the correct user associated with this course and compares it to the current user
    correct_user_id=@course.user_id
    redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
  end


end

