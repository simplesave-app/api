module Api
  module V1
    class RootController < BaseController
      def index
        render json: {
          name: "SimpleSave API",
          version: "v1",
          status: "ok"
        }
      end
    end
  end
end
