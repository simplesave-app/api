module Api
  module V1
    class HealthController < BaseController
      def index
        render json: { status: "ok" }, status: :ok
      end
    end
  end
end
