## This task loads sample data into course with id 1
task :loadTestDataCSV => :environment do
	upload(Assignment, 'assignments.csv')
	upload(Tag, 'tags.csv')
	upload(TagAssignment, 'tag_assignments.csv')
	upload(Student, 'students.csv')
	grade_upload('grades.csv')
end


task :loadTestDataJSON => :environment do
	jsonload(Course, 'course.json')
end

## This task deletes the test data for course 1.
task :removeTestDataCSV => :environment do #actually this removes all the data. don't trust this name
	Assignment.where(:course_id => 1).delete_all
	Tag.where(:course_id => 1).delete_all
	# TagAssignment.delete_all deleted in cascade
	# Course.delete_all
	Student.where(:course_id => 1).delete_all
end

def upload (model, filename)
	require 'csv'   
	filepath= 'db/sample-data/'+filename
	csv_text = File.read(filepath)
	csv = CSV.parse(csv_text, :headers => true)
	csv.each do |row|
 	 model.create!(row.to_hash)
	end
end

## Should be refactored - uses same format as UI grades uploader
def grade_upload(filename)
	require 'csv'   
	filepath= 'db/sample-data/'+filename
	csv_text = File.read(filepath)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      studentgrades=row.to_hash
      student=Student.where(course_id: "1", email: studentgrades["email"]).first
      student.grades.destroy_all
      studentgrades.each do |key, value|
        unless key=="email"
          student.grades.create(:points=>value.to_i, :assignment_id=>key.split("_").first.to_i)
        end
      end
    end
end

def jsonload (model, filename)
	filepath= 'db/sample-data/'+filename
	json_text = File.read(filepath)
	data = JSON.parse(json_text)
 	model.create!(data)
end

