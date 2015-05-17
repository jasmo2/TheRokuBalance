module Api
  class AppsController < Api::ApplicationController
    before_action :authenticate_token!

    def index
      apps = @current_user.apps
      data = apps.map do |a|
        {
          subdomain: a.subdomain,
          url1: a.url1,
          url2: a.url2,
        }
      end
      render json: data, status: :ok
    end

    def create
      app = App.new(app_params)
      app.user_id = @current_user.id
      if app.save
        render json: {Tryceratops: "created"}, status: :ok
      else
        render json: {errors: app.errors}, status: 417
      end
    end

    def destroy
      app = App.where(user_id: @current_user.id, subdomain: params[:id]).take
      tryceratops_name = app.subdomain if app != nil
      if app && app.destroy
        render json: {deleted: "Tryceratops #{tryceratops_name}"}, status: :ok
      else
        render json: {errors: "couldn't delete app"}, status: 417
      end
    end

    def update
      app = App.where(user_id: @current_user.id,subdomain: params[:id]).take
      if app && app.update(app_params)
        render json: {updated: "Tryceratops #{app.subdomain}"}, status: :ok
      else
        ans = app != nil ? app.errors : "couldn't update"
        render json: {errors:  ans }, status: 417
      end
    end
    private
    def app_params
      params.permit(:url1, :url2, :subdomain)
    end
  end
end
