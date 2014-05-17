class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]

  # include activemerchant and its helper
  include ActiveMerchant::Billing::Integrations
  require 'active_merchant/billing/integrations/action_view_helper'
  ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
  ActiveMerchant::Billing::Base.integration_mode = :development # use wp3 sandbox

  # return url from gateway that updates order status
  def return_action
    returned = WebPay3::Return.new(request.query_string, :key => Merchant.new.key)

    @order = Order.find_by_order_number(returned.order_number)

    if returned.cancelled?
      redirect_to @order, notice: "Order has been cancelled. <br>Params: #{params.inspect}."
    elsif returned.success?
      @order.status = 'Approved'
      @order.save!
      redirect_to @order, notice: "Order has been approved. <br>Params: #{params.inspect}."
    else
      @order.status = "Declined"
      @order.save!
      redirect_to @order, alert: "Order Failed. Digest does not match."
    end

  end

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.order('id desc')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.status = 'Pending'

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:order_number, :currency, :amount)
    end
end
