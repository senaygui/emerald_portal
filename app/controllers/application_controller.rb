class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true, with: :exception

  def home
    render html: 'Welcome to Emerald International College '
  end

  def access_denied(exception)
    flash[:error] = exception.message

    redirect_to admin_root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end

  def current_ability
    @current_ability ||= if current_admin_user.is_a?(AdminUser)
                           Ability.new(current_admin_user)
                         else
                           UserAbility.new(current_student)
                         end
  end
  # def after_sign_in_path_for(resource)
  #  if current_admin_user.present?
  #   admin_root_path
  #  elsif current_student.sign_in_count == 1
  #   edit_student_registration_path(update_pwd: "update_pwd")
  #  else
  #   root_path
  #  end
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    
    devise_parameter_sanitizer.permit(:sign_up) do |student_params|
      student_params.permit(:first_name, :middle_name, :last_name, :email, :password, :password_confirmation, :gender, :date_of_birth, :moblie_number, :alternative_moblie_number,:country, :region, :city, :photo, :program_id, :batch_id, :fully_attended, :fully_attended_date,:student_id, :student_password, :created_by, :last_updated_by,:photo)
    end

    devise_parameter_sanitizer.permit(:account_update) do |student_params|
      student_params.permit(:first_name, :middle_name, :last_name, :email, :password, :password_confirmation, :gender, :date_of_birth, :place_of_birth, :moblie_number, :alternative_moblie_number,:country, :region, :city, :photo, :program_id, :batch_id, :account_status,:graduation_status, :fully_attended, :fully_attended_date, :sponsorship_status,:student_id, :student_password, :created_by, :last_updated_by,:photo)
    end

    devise_parameter_sanitizer.permit(:sign_in) do |student_params|
      student_params.permit(:email, :password, :remember_me)
    end
  end
end
