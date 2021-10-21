class DashboardController < ApplicationController
  def index
    @sales_group_by_month = Sale.group_by_month(:created_at).sum(:amount)

    @sales_group_by_month_count = Sale.group_by_month(:created_at).count

    @sales_group_by_month_average = Sale.group_by_month(:created_at).average(:amount)

    @sales_count_by_origin_12m = Coffe.joins(:sales).where('sales.created_at > ? ', 1.year.ago).group(:origin).count
 
    @sales_count_by_origin_6m = Coffe.joins(:sales).where('sales.created_at > ? ', 6.month.ago).group(:origin).count
  
    @sales_count_by_origin_3m = Coffe.joins(:sales).where('sales.created_at > ? ', 3.month.ago).group(:origin).count
  
    @sales_count_by_origin_1m = Coffe.joins(:sales).where('sales.created_at > ? ', 1.month.ago).group(:origin).count
  
    @sales_count_by_blend_12m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 1.year.ago).group(:blend).count
  
    @sales_count_by_blend_6m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 6.month.ago).group(:blend).count
    @sales_count_by_blend_3m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 3.month.ago).group(:blend).count
    @sales_count_by_blend_1m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 1.month.ago).group(:blend).count
  
  end
end
