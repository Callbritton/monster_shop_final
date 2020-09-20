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
      flash[:notice] = "All fields must be completed. Please try again."
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    if discount.save
      flash[:success] = "Discount has been updated!"
      redirect_to "/merchant/discounts"
    else
      flash[:notice] = "All fields must be completed. Please try again."
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end


  private

  def discount_params
    params.permit(:name, :percent, :minimum_quantity)
  end
end
