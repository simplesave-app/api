module Api
  module V1
    class ApplicationController < BaseController
      def index
        render html: "Hello, World!"
      end
    end
  end
end
