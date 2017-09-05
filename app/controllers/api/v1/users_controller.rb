class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  respond_to :json

  def index
    begin
      respond_with User.all
    rescue => e
      Rails.logger.error { "Error generated for nil user: #{user_id}, #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  def show
    begin
      respond_with User.find(user_id)
    rescue => e
      Rails.logger.error { "Error generated for nil user: #{user_id}, #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  def create
    begin
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: 201, location: api_user_url(@user)
      else
        render json: { errors: @user.errors }, status: 422
      end
    rescue => e
      Rails.logger.error { "Error generated while creating user on: #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  def update
    begin
      if @user.update(user_params)
        render json: @user, status: 200, location: api_user_url(@user)
      else
        render json: { errors: @user.errors }, status: 422
      end
    rescue => e
      Rails.logger.error { "Error generated while finding user for: #{user_id}, #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  def destroy
    begin
      @user.destroy
      head 204
    rescue => e
      Rails.logger.error { "Error generated while destroying user for: #{user_id}, #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    begin
      @user = User.find(user_id)
    rescue => e
      Rails.logger.error { "Error generated while finding user for: #{user_id}, #{e.message} #{e.backtrace.join("\n")}" }
      nil
    end
  end

  def user_id
    params[:id]
  end
end
