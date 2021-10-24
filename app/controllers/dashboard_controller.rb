class DashboardController < ApplicationController
  def index
    # 1. Chart with the month's sales of the last 12 months
    @sales_group_by_month = Sale.group_by_month(:created_at).sum(:amount)

    # 2. Chart with the month sales quantity of the last 12 months
    @sales_group_by_month_count = Sale.group_by_month(:created_at).count

    # 3. Chart with the average month sales of the last 12 months
    @sales_group_by_month_average = Sale.group_by_month(:created_at).average(:amount)

    # 4. Pie chart with the sales quantity according to the coffee origin:
    @sales_count_by_origin_12m = Coffe.joins(:sales).where('sales.created_at > ? ', 1.year.ago).group(:origin).count
    @sales_count_by_origin_6m = Coffe.joins(:sales).where('sales.created_at > ? ', 6.month.ago).group(:origin).count
    @sales_count_by_origin_3m = Coffe.joins(:sales).where('sales.created_at > ? ', 3.month.ago).group(:origin).count
    @sales_count_by_origin_1m = Coffe.joins(:sales).where('sales.created_at > ? ', 1.month.ago).group(:origin).count
  
    # 5. Pie chart with the sales quantity according to the blend of coffee:
    @sales_count_by_blend_12m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 1.year.ago).group(:blend).count
    @sales_count_by_blend_6m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 6.month.ago).group(:blend).count
    @sales_count_by_blend_3m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 3.month.ago).group(:blend).count
    @sales_count_by_blend_1m = Coffe.left_outer_joins(:sales).where('sales.created_at > ?', 1.month.ago).group(:blend).count
  end
end
