# Cafeteria dashboard

The present project involves the implementations of graphics to display business information of a Cafeteria.

## Ruby & Rails version

```ruby
* ruby '2.6.1'
* gem 'rails', '~> 5.2.6'
```

## Ruby & Rails Gems

```ruby
gem "faker", "~> 2.19"
gem "chartkick", "~> 4.0"
gem "groupdate", "~> 5.2"
gem "bootstrap", "~> 5.1"
gem "jquery-rails", "~> 4.4"
```

## Incorporating Bootstrap

In the Gemfile is it added:

```ruby
# gemfile.rb

gem "bootstrap", "~> 5.1"
gem "jquery-rails", "~> 4.4"
```

Then, called from the JavaScript manifest:

```javascript
// application.js

//= require jquery3
//= require popper
//= require bootstrap
```

And called from the stylesheets:

```css
/* dashboard.scss */

@import 'bootstrap';
```

## Defining the models

![coffe](/assets/images/coffe.png)

As it can be seen above, the relation it is a *has_many* association and the models are generated as it follows:

```console
rails g model Coffe name price:integer origin blend
rails g model Sale amount:integer coffe:references
```

In the models the relation is added as:

```ruby
class Coffe < ApplicationRecord
    has_many :sales
end
```

```ruby
class Sale < ApplicationRecord
  belongs_to :coffe
end
```

It is checked in the Rails console as:

```console
Coffe.new.sales
Sale.new.coffe
```

Also, the controller is generated as:

```console
rails g controller Dashboard index
```

## Populating the database

With the help of the Faker Gem, the database is populate as it follows:

From the console:

```console
bundle add faker
```

Then the dummy data is generated:

```ruby
# seeds.rb

30.times do
    Coffe.create(name: Faker::Name.name,
    price: rand(1990..5490),
    origin: Faker::Coffee.origin,
    blend: Faker::Coffee.blend_name
    )
end

200.times do
    Sale.create(amount: rand(2000..10000),
    coffe_id: rand(Coffe.first.id..Coffe.last.id),
    created_at: Faker::Date.between(from: 1.year.ago, to: Date.today)
    )
end
```

Again, from the console:

```console
rails db:seed
```

## Incorporating the graphics

The main gems needed for the graphics are added:

```ruby
gem "chartkick", "~> 4.0"
gem "groupdate", "~> 5.2"
```

Then, called from the js manifest:

```javascript
//= require chartkick
//= require Chart.bundle
//= require highcharts
```

### Generating the charts

First, the charts are defined in the controller as it follows:

```ruby
# controllers/dashboard_controller.rb

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
```

And finally, these are called from the index as:

```ruby
# dashboard/index.html

<%= column_chart @sales_group_by_month %>

<%= column_chart @sales_group_by_month_count %>

<%= column_chart @sales_group_by_month_average %>

<%= pie_chart @sales_count_by_origin_12m %>
<%= pie_chart @sales_count_by_origin_6m %>
<%= pie_chart @sales_count_by_origin_3m %>
<%= pie_chart @sales_count_by_origin_1m %>

<%= pie_chart @sales_count_by_blend_12m %>
<%= pie_chart @sales_count_by_blend_6m %>
<%= pie_chart @sales_count_by_blend_3m %>
<%= pie_chart @sales_count_by_blend_1m %>
```