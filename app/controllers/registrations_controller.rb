class RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_roles_by_category, only: [:edit]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username, :email])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name, :username, :email, :avatar, :description, :years_of_experience,
      role_ids: [], 
      skill_ids: [],
      custom_roles: [:name, :category]
    ])
  end

  def set_roles_by_category
    @roles_by_category = Role.order(:category, :name).group_by(&:category)
  end

  def update_resource(resource, params)
    # 비밀번호가 비어있으면 비밀번호 없이 업데이트
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      params.delete(:current_password)

      # 기술 스택과 역할 ID 처리
      if params[:skill_ids].present?
        params[:skill_ids] = params[:skill_ids].map do |id|
          if id.start_with?('skill_')
            # 새로운 기술 스택 생성
            name = id.sub('skill_', '')
            Skill.find_or_create_by!(name: name).id
          else
            id.to_i
          end
        end.compact
      end

      if params[:role_ids].present?
        # 커스텀 역할 처리
        custom_roles = params[:custom_roles] || []
        custom_role_ids = custom_roles.map do |role_data|
          next if role_data[:name].blank? || role_data[:category].blank?
          
          # 동일한 이름과 카테고리의 역할이 있는지 확인
          Role.find_or_create_by!(
            name: role_data[:name],
            category: role_data[:category]
          ).id
        end.compact

        # 기존 역할 ID와 새로 생성된 역할 ID 합치기
        params[:role_ids] = params[:role_ids].select { |id| id.to_s.match?(/\A\d+\z/) }.map(&:to_i) + custom_role_ids
      end

      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
