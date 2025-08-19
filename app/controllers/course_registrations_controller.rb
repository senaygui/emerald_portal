class CourseRegistrationsController < ApplicationController
  before_action :set_course_registration, only: [:show, :edit, :update, :destroy]

  def index
    @course_registrations = CourseRegistration.all
  end

  def show
  end

  def new
    @course_registration = CourseRegistration.new
  end

  def create
    @course_registration = CourseRegistration.new(course_registration_params)
    if @course_registration.save
      redirect_to @course_registration, notice: 'Course registration was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course_registration.update(course_registration_params)
      redirect_to @course_registration, notice: 'Course registration was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @course_registration.destroy
    redirect_to course_registrations_url, notice: 'Course registration was successfully destroyed.'
  end

  def enroll
    student = current_student
    return redirect_to root_path, alert: 'No program or course found.' unless student&.program && student.program.courses.any?
    if !student.course_registrations.present?
        # If the student has no course registrations, enroll them in the first course
        # This assumes the first course is the one they should start with
        course = student.program.courses.where(course_order: 1).first || student.program.courses.first 
    elsif student.course_registrations.count == student.program.courses.count
        # If the student has registered for all courses, redirect to a message
        return redirect_to root_path, alert: 'You have already registered for all courses in your program.'
    else
        # If the student has course registrations, enroll them in the next course based on order
        last_course = student.course_registrations.order(created_at: :desc).first
        next_course_order = last_course ? last_course.course.course_order + 1 : 1
        course = student.program.courses.where(course_order: next_course_order).first || student.program.courses.first
    end
    return redirect_to root_path, alert: 'No course found.' unless course

    # Create course registration
    course_registration = CourseRegistration.create(
      student_id: student.id,
      course_id: course.id,
      program_id: student.program.id,
      batch_id: student.batch&.id,
      student_full_name: student.full_name,
      course_title: course.course_title,
      created_by: 'system',
      created_at: Date.current
    )

    # Create invoice
    invoice = Invoice.create(
      student_id: student.id,
      invoice_number: "INV-#{SecureRandom.hex(4).upcase}",
      program_id: student.program.id,
      batch_id: student.batch&.id,
      total_price: course.course_price || 0,
      invoice_status: 'unpaid',
      due_date: Date.current + 30.days,
      created_by: 'system',
      student_full_name: student.full_name,
      student_id_number: student.student_id
    )
    invoice_item = InvoiceItem.create do |invoice_item|
        invoice_item.itemable_id = invoice.id
        invoice_item.itemable_type = "Invoice"
        invoice_item.course_registration_id = course_registration.id
        invoice_item.created_by = course_registration.created_by
        invoice_item.price = course_registration.course.course_price
        invoice_item.created_by = "system"
    end


    if invoice.persisted?
        Notification.create!(
            student_id: invoice.student.id,
            notifiable: invoice,
            notification_status: 'warning',
            notification_message: "Thank you for enrolling in the course. Please pay the invoice to complete your registration.",
            notification_card_color: "warning",
            notification_action: "pay"
        )
        redirect_to invoice_path(invoice), notice: 'Course enrolled and invoice generated.'
    else
        redirect_to course_registrations_path, alert: 'Enrollment succeeded, but invoice creation failed.'
    end
  end

  private
    def set_course_registration
      @course_registration = CourseRegistration.find(params[:id])
    end

    def course_registration_params
      params.require(:course_registration).permit(:student_id, :course_id, :status, :registered_on)
    end
end
