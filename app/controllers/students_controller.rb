class StudentsController < ApplicationController

  #before_action :verify_user_by_course, only: [:new, :destroy]
  before_action :verify_user_by_course, only: [:new, :create]
  before_action :check_ownership, only: [:destroy]
  before_filter :view    #OMG THIS WORKS!!!! 

  # GET /students
  # GET /students.json
  def index
    @students = Student.where(:course_id => params[:course_id])
  end


  def new
    @course = Course.new
  end

  def create
    @course = Course.find(params[:course_id])
    @student = @course.students.create(student_params)

    if @student.save
      redirect_to students_url(:course_id => params[:course_id])
    else
      render action: 'new'
    end
  end

  def update
    @course = Course.find(params[:course_id])
    @student = @course.students.find(params[:id])
    @student.update(:email => params[:student][:email])
    if @student.save
      redirect_to students_url(:course_id => params[:course_id])
    else 
      render action: 'edit'
    end
  end

  #view Flowchart
  def viewFlowChart
    @course = Course.find(params[:course_id])
    render 'flowchartStudentList'
  end



  def new
    @student = Student.new
  end

  def edit
    @course = Course.find(params[:course_id])
    @student = @course.students.find(params[:id])
  end

  def destroy
    if Student.destroy(params[:id])
      redirect_to students_url(:course_id => params[:course_id])
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:email)
  end

  #gets passed in the random URL
  def view
    @isSample = false
    #use to show sample flowchart
    if params[:isSample] == "yes"
      @isSample = true
      @course = Course.find(params[:course_id])
    end
    #end
    
    @tagassignments=TagAssignment.all
    @student=Student.where(random_url: params[:id]).first
    #use to show sample flowchart
    if params[:isSample] == "yes"
      @student=Student.where(course_id: params[:course_id]).first
    end
    #end

    #end
    if !@student.nil? #case 1: viewing the grade view page
      @course=Course.find(@student.course_id)
      @tags = @course.tags.group(:name)
      
      @nodes=Assignment.where(course_id: @student.course_id).map {|x|x}
      #add individualized grade and tag data to each node
      @totalpoints=0
      @nodes.each do |node|
        #modyfied 
        if node.points_possible.nil?
          @totalpoints = 10
        else
          @totalpoints+=node.points_possible
        end
        grade=Grade.where(student_id: @student.id, assignment_id: node.id).first
        if grade.nil?
         node["points"]=0
       else
         node["points"]=grade.points
       end
	       #node["tagnames"]=node.tags.map{|x|x}
         node["tagnames"] = ""
         idx = 0
         @course.tags.each do |t|
          if (t.course_id == @student.course_id) && (t.assignmentnames == node.name)
              node["tagnames"] = node["tagnames"] + t.name + ','
          end
        end

      end
    else #case 2: accessing the list of students to edit, add, or destroy
      #do nothing; we don't need the else actually. i put it there so that i can do some explaining




    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def student_params
    params.require(:student).permit(:course_id, :email)
  end

  def check_ownership
    @course = Course.find(Student.find(params[:id]).course_id)
    #finds the correct user associated with this course and compares it to the current user
    correct_user_id=@course.user_id
    redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
  end


end
