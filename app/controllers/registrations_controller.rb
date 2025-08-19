class RegistrationsController < Devise::RegistrationsController
  before_action :check_permit, only: [:update_document]
  # private

  # def after_sign_up_path_for(resource)
  # 	# if user_signed_in?
  # 	# 	payment_path
  # 	# end
  # end
  # def new
  #    super do |resource|
  #      resource.build_student_address
  #    end
  #  endp
  def new
    # Override Devise default behaviour and create a profile as well
    build_resource({})
    respond_with resource
  end

  def update_profile_photo
    current_student.photo.attach(check_permit[:photo])
    redirect_to profile_url
  end



  # AJAX endpoint for email uniqueness check
  def check_email
    email = params[:email].to_s.strip.downcase
    taken = Student.exists?(email:)
    render json: { taken: }
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params.except('current_password'))
  end

  private

  def check_permit
    params.require(:student).permit(:photo)
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up) do |student_params|
  #     student_params.permit(:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
  #   end
  #   devise_parameter_sanitizer.permit(:account_update) do |student_params|
  #     # student_params.permit(:original_degree_submission_date,:original_degree_status,:created_by,:last_updated_by,:photo,:email,:password,:password_confirmation,:first_name,:last_name,:middle_name,:gender,:student_id,:date_of_birth,:program_id,:department,:admission_type,:study_level,:marital_status,:year,:semester,:account_verification_status,:document_verification_status,:account_status,:graduation_status,student_address_attributes: [:id,:country,:city,:region,:zone,:sub_city,:house_number,:cell_phone,:house_phone,:pobox,:woreda,:created_by,:last_updated_by],emergency_contact_attributes: [:id,:full_name,:relationship,:cell_phone,:email,:current_occupation,:name_of_current_employer,:pobox,:email_of_employer,:office_phone_number,:created_by,:last_updated_by], documents: [])
  #   end
  #   devise_parameter_sanitizer.permit(:sign_in) do |student_params|
  #     student_params.permit(:email, :password)
  #   end
  # end
end
