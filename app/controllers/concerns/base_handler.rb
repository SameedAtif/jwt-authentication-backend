module BaseHandler
  extend ActiveSupport::Concern

  def model
    controller_name.camelize.singularize.constantize
  end

  class_methods do
    def actions(*actions)
      send :public, *actions
    end
  end
end