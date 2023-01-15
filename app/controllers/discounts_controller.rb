class DiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @discounts = @merchant.discounts
    end

    def show
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.discounts.find(params[:id])
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create
        @merchant = Merchant.find(params[:merchant_id])
        @merchant.create_discount(params[:percent], params[:quantity])
        redirect_to merchant_discounts_path(@merchant)
    end

    def edit
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.discounts.find(params[:id])
    end

    def update
        @merchant = Merchant.find(params[:merchant_id])
        @discount = @merchant.discounts.find(params[:id])
        @discount.edit_discount(params[:percent], params[:quantity])
        redirect_to merchant_discount_path(@merchant, @discount)
    end

    def destroy
        @merchant = Merchant.find(params[:merchant_id])
        @merchant.remove_discount(params[:id])
        redirect_to merchant_discounts_path(@merchant)
    end
end