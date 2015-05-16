class TagAssignmentsController < ApplicationController
#      before_action :verify_user_by_course, only: [:new, :destroy]
  before_action :verify_user_by_course, only: [:create]
  before_action :check_ownership, only: [:destroy]

def create
      @tag_assignment = @course.tag_assignments.create(tag_assignment_params)
end

def destroy
    #TagAssignment.destroy(params[:id]) #TODO TRYING THIS TO SEE IF IT SOLVES THE DESTROY PROBLEM WHEN DEPLOYED	
    @tag_assignment.destroy #TODO 
end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_assignment_params
      #params.require(:tag_assignment).permit(:tag_id, :assignment_id)
      params.require(:tag_assignment).permit(:course_id, :tag_id, :assignment_id)
    end

    def check_ownership
      @course = Course.find(TagAssignment.find(params[:id]).course_id)
      #finds the correct user associated with this course and compares it to the current user
      correct_user_id=@course.user_id
      redirect_to(signin_url, notice:'Incorrect User') unless current_user.id==correct_user_id
    end
end
