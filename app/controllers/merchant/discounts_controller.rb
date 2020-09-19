class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      flash[:success] = "Your discount has been created"
      redirect_to "/merchant/discounts"
    else
      flash[:notice] = "Something has gone wrong, please try again"
      redirect_to "/merchant/discounts/new"
    end
  end


  private

  def discount_params
    params.permit(:name, :percent, :minimum_quantity)
  end
end
