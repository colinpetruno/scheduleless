module Admin
  class FeaturesController < AdminController
    def create
      @feature = Feature.new(feature_params)

      if @feature.save
        redirect_to admin_features_path
      else
        render :new
      end
    end

    def edit
      @feature = Feature.find(params[:id])
    end

    def index
      @features = Feature.all
    end

    def new
      @feature = Feature.new
    end

    def update
      @feature = Feature.find(params[:id])

      if @feature.update(feature_params)
        redirect_to admin_features_path
      else
        render :edit
      end
    end

    private

    def feature_params
      params.require(:feature).permit(:description, :key)
    end
  end
end
