class CoursesController < ApplicationController
  before_action :signed_in, only: [:new, :edit, :show, :edit, :update, :destroy, :upload, :download, :mail, :index]
  #before_action :correct_user_set_course, only: [:show, :edit, :update, :destroy, :upload, :download, :mail]
  before_action :verify_user_by_course, only: [:show, :edit, :update, :destroy, :upload, :download, :mail]

  #new CSV feature
  require 'csv'
  @@csv_object_active = nil
  @@row_modify = 0
  @@f_name = nil
  @@current_course_name = nil
  @@course_active = nil
  @@new_course_id = nil
  #new CSV feature



  #new csv feature
  def viewCourseInfo
    @@f_name = Csvmngr.where(email: current_user.email, filename: @@f_name).take.filename
    file_name_path = "Csvcourses/" + @@f_name
    @csv_object_now = CSV.read(file_name_path)
    @@csv_object_active = @csv_object_now
    render 'csv_visual'
  end 

  def editStudentRecord
    @row_num = params[:row]
    @@row_modify = @row_num
    @csv_object = @@csv_object_active
    @student_record = @@csv_object_active[@row_num.to_i]
    render 'editStudentRecords'
  end

  def submitStudentRecord
    i = 0
    params[:data].each do |d|
      @@csv_object_active[@@row_modify.to_i][i] = params[:data][i.to_s]
      i = i + 1
    end
    @csv_object_now = @@csv_object_active
    @test_row_modify = @@row_modify
    @test_f_name = @@f_name
    #write to a new CSV file
    file_name_path = "Csvcourses/" + @@f_name
    CSV.open(file_name_path, 'w') do |csv_object|
      @csv_object_now.each do |row_array|
        csv_object << row_array
      end
    end
    render 'csv_visual'
  end

  def addInfoForNewCourse
    @course = Course.new
    render 'addInfoForNewCourse'
  end

  def uploadCsvCreateCourse
    @@current_course_name = params[:courseName]
    render 'uploadCsvCreateCourse'
  end

  def storeUploadedFile
    if !params[:uploadFile].nil? 
      file_io = params[:uploadFile] 
      file_upload(file_io, @@current_course_name)
    else
      render 'nosuchfile'
    end
  end

  #sub_function of storeUploadedFile 
  def file_upload(upload, course_name)
    begin
      FileUtils.mkpath(upload_path) unless File.directory?(upload_path)
      if upload.kind_of?(StringIO)
        upload.rewind
      end
      #upload = StringIO.new(upload)
      orig_name = upload.original_filename
      base_name = File.basename(orig_name, ".*")
      ext_name = File.extname(orig_name)
      file_name = base_name  + '_' + current_user.email + '_' + @@current_course_name + ext_name
      File.open(upload_path(file_name), "wb") { |f| f.write(upload.read) }
    rescue
      raise
    end
    #a new record in Csvmngr db
    @csvname_for_course = Csvmngr.new
    @csvname_for_course.instructor = current_user.name
    @csvname_for_course.email = current_user.email
    @csvname_for_course.filename = file_name
    @csvname_for_course.courseid = @@new_course_id
    @csvname_for_course.save!
    @@f_name = file_name
    #parse all students to db and parse all courses assignments
    file_name_path = "Csvcourses/" + @@f_name
    @csv_object_now = CSV.read(file_name_path)
    @@csv_object_active = @csv_object_now
    create_course_from_csv
  end

  # select tags
  def addTagForCourse
    #render 'test_add_tag'
    idx = 0
    @@csv_object_active[0].each do |o|
      if idx > 1
        #split tag string contains ';'
        tagArrForOneAssignment = params[:data][idx.to_s].split(';')
        tagArrForOneAssignment.each do |t|
          @new_tag = Tag.new
          @new_tag.name = t
          @new_tag.course_id = @@course_active.id
          @new_tag.assignmentnames = @@csv_object_active[0][idx.to_i]
          if @new_tag.name.nil? or !@new_tag.name.empty?
            @new_tag.save!
          end
        end
      end

      idx = idx + 1
    end
    #viewCourseInfo
    @csv_object_ll = @@csv_object_active[0]
    @courses = Course.where(user_id: current_user.id)
    render 'index'
  end


  def upload_path(file_name = nil)
    "Csvcourses/#{file_name.nil? ? '' : file_name}"
  end

  #new CSV feature 
  def create_course_from_csv
    if Course.where(name: @@current_course_name, user_id: current_user.id).take.nil?
      @course = Course.new
      @course.name = @@current_course_name
      @course.user_id = current_user.id
      @course.save!
      @@new_course_id = @course.id
      assignment_begin_id = 0
      col_idx = 0
      @csv_object_now[0].each do |col|
        if col_idx > 1
          @assignment = Assignment.new
          @assignment.name = col
          match = col.match(/\[\d+\]/)[0].to_s
          match_len = match.size
          @assignment.points_possible = match[1..(match_len-2)].to_i
          @assignment.course_id = @course.id
          @assignment.save!
          assignment_begin_id = @assignment.id - (@csv_object_now[0].size - 2)
        end
        col_idx = col_idx + 1
      end
      dummy = 0
      @csv_object_now.each do |row|
        if dummy > 0
          @student = Student.new
          @student.email = row[1]
          @student.course_id = @course.id
          @student.save!
          dummy_idx = 0
          row.each do |g|
            #if dummy_idx > 0
            @grade = Grade.new
            @grade.student_id = @student.id
            @grade.points = g
            @grade.assignment_id = assignment_begin_id + dummy_idx
            @grade.save!
            dummy_idx = dummy_idx + 1
            #end
          end 
        end
        dummy = dummy + 1
      end
      @course.save!
      @@course_active = @course
      @csv_object = @@csv_object_active
      @student_record = @@csv_object_active[0]
      flash[:success] = 'Course was successfully created.'
      render 'addtagpage'
    else
      @csv_object = @@csv_object_active
      @student_record = @@csv_object_active[0]
      render 'addtagpage'
    end
  end 
  #new CSV feature

  #new CSV feature
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.where(user_id: current_user.id)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @hha = "test"
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  def upload
    csv_text = params[:file].read()
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      studentgrades=row.to_hash
      student=Student.where(course_id: params[:id], email: studentgrades["email"]).first
      student.grades.destroy_all
      studentgrades.each do |key, value|
       unless key=="email"
         student.grades.create(:points=>value.to_i, :assignment_id=>key.split("_").first.to_i)
       end
     end
   end
   flash[:notice]="File uploaded"
   redirect_to course_path(params[:id])
 end
 public :upload

 def download
  respond_to do |format|
    format.csv { 
     assignments=Assignment.where(course_id: params[:id]).map{|x| x.id.to_s+"_"+x.name+" ("+x.points_possible.to_s+")"}
     assignments.unshift("email")
     studentemails=Student.where(course_id: params[:id]).map{|x| x.email}
     csv_string = CSV.generate do |csv|
       csv << assignments
       studentemails.each do |email|
         studentrow=Array.new(assignments.size-1)
         studentrow.unshift(email)
         csv << studentrow
       end
     end
     response.headers['Content-Disposition'] = 'attachment; filename="' + "course_"+ params[:id] + '.csv"'
     render text: csv_string
   }
 end
end

  # POST /courses
  # POST /courses.json
  def create
    @course=current_user.courses.create(course_params)
    find_existing_student_user

    #check if user_id attribute of course is assigned
    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  def mail
    @course = Course.find(params[:id])
    @course.students.each do |student|
      StudentMailer.gradeview_email(student).deliver
    end
    flash[:notice]="Students emailed"
    redirect_to course_path(@course.id)
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    #    respond_to do |format|
    if @course.update(course_params)
      #        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
      #        format.json { head :no_content }
      redirect_to @course, notice: 'Course was successfully updated.' #TODO THIS IS IN AJAX
    else
      #        format.html { render action: 'edit' }
      #        format.json { render json: @course.errors, status: :unprocessable_entity }
      render action: 'edit' #TODO THIS IS IN AJAX TOO
    end
  end
  #  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url }
    end
  end

  private
  def correct_user_set_course
    @course = Course.find(params[:id])
    #finds the correct user associated with this course and compares it to the current user
    correct_user_id=@course.user_id
    redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    result = params.require(:course).permit! #TODO see if this make the course save info
    if !result["students_attributes"].nil?
      result["students_attributes"] = JSON.parse(result["students_attributes"])
    end
    if !result["assignments_attributes"].nil?
      result["assignments_attributes"] = JSON.parse(result["assignments_attributes"])
    end
    if !result["tags_attributes"].nil?
      result["tags_attributes"] = JSON.parse(result["tags_attributes"])
    end
    #params.require(:course).permit(:name, :students_attributes, :assignments_attributes, :tags_attributes) #TODO THIS IS IN AJAX THREE
    return result
  end


  #look through all student user objects and see if there's an existing user that has the same email
  def find_existing_student_user
    @course.students.each do |student|
      #@student_user = StudentUser.where(email: student[:email]).first
      if @user = User.where(email: student[:email]).first #IMPORTANT: SEARCH FOR USER NOT STUDENT_USER!!!!!!!!!
       logger.info "&&&&&&&&&&& courses controller: record exists!!"
	#@student_user.student = student #DOESN'T WORK
	#student.student_user = @user 
	@student_user = StudentUser.find_by(id: @user[:identifiable_id])
	next if @student_user.nil?
	@student_user.student = student

	student[:student_user_id] = student.student_user[:id] #TODO 
	@student_user[:student_id] = student[:id]

end
end
end





end
