module Api
  module V1
    class AuthController < ApplicationController
      def register
        user = User.new(user_params)

        if user.save
          session = Session.create!(user_id: user.id)

          render json: {
            token: session.token,
            user: {
              id: user.id,
              email: user.email
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: user_params[:email])

        if user&.authenticate(user_params[:password])
          session = Session.create!(user_id: user.id)

          render json: {
            token: session.token,
            user_id: user.id
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      rescue ActionController::ParameterMissing
        {}
      end
    end
  end
end
