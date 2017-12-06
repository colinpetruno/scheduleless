module Marketing
  class CompanyInquiriesController < BaseController
    def create
    end

    def new
      @inquiry = CompanyInquiry.new
    end
  end
end
