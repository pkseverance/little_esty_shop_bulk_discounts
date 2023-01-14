class DiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @discounts = @merchant.discounts
    end

    def show
        
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        @merchant.discounts.create!(percent_discount: params[:percent], quantity_threshold: params[:quantity])
        redirect_to merchant_discounts_path(@merchant)
    end
end