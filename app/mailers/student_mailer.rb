class StudentMailer < ActionMailer::Base
  default from: "flowghostapp@gmail.com"

    def gradeview_email(student)
    @student = student
    @course = Course.where(id: @student.course_id).first
    mail(to: @student.email, subject: 'FlowGhost Grade Report Available')
  end
end
