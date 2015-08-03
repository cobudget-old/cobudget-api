class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::ImplicitRender
  include ActionController::Serialization
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :json

private
  def user_not_authorized
    render json: { errors: { user: ["not authorized to do this"] } }, status: 403
  end

  # CRUD helpers
  #

  def resource
    @resource ||= controller_name.classify.constantize.find(params[:id])
  end

  def create_resource(controller_params, **args)
    resource = controller_name.classify.constantize.new(controller_params)
    authorize resource
    resource.save
    if args[:respond] == false
      resource
    else
      respond_with resource
    end
  end

  def update_resource(controller_params)
    authorize resource
    respond_with resource.update_attributes(controller_params)
  end

  def destroy_resource
    authorize resource
    respond_with resource.destroy
  end

  # def resource_class
  #   resource_name.camelize.constantize
  # end

  def resource_plural
    controller_name
  end

  def serializer_root
    controller_name
  end

  def resource
    instance_variable_get :"@#{resource_name}"
  end

  def resource_name
    controller_name.singularize
  end

  def resource_serializer
    "#{resource_name}_serializer".camelize.constantize
  end

  def respond_with_errors
    render json: {errors: resource.errors.as_json()}, root: false, status: 422
  end

  def respond_with_resource(scope: {}, serializer: resource_serializer)
    if resource.errors.empty?
        render json: [resource], root: serializer_root, each_serializer: serializer
    else
      respond_with_errors
    end
  end
end
