class StudentTemporaryController < ApplicationController

  def generate_pdf
    program_id = params[:program][:name]
    degree = params[:degree]
    gc_date = params[:gc][:date]
    study = params[:study]

    program = Program.find(program_id)
    students = filter_student_for_tempo(program, study)
    redirect_to student_temporary_url, alert: "We could not find a student matching your search criteria. Please please check student graduation status is approved" if students.empty?
    if students.any?
      respond_to do |format|
        format.html
        format.pdf do
          pdf = StudentTemporary.new(students, degree, gc_date)
          send_data pdf.render, filename: "#{study}_#{program.program_name}_program.pdf", type: "application/pdf", disposition: "inline"
        end
      end
    end
  end

end
