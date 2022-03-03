# Store Agenda challenge

The versions that you need to run this test:

* Ruby 3.0.1

* Rails 6.1.4.4


## Step by Step - Run application

* bundle install

* rails db:create && rails db:migrate
* initialize sku's on databse with "rails db:seed"


```
Database Sqlite included
```

## Run rails server

bundle exec rails server 

## Examples

Get invoice calculations
http://localhost:3000/api/v1/invoices?id=TSHIRT,TSHIRT,TSHIRT
http://localhost:3000/api/v1/invoices?id=MUG,TSHIRT,TSHIRT,TSHIRT,MUG,MUG

Get material prices
http://localhost:3000/api/v1/material_prices

PUT price
http://localhost:3000/api/v1/material_prices/TSHIRT
{
    "price" : 30.99
}


## Run tests

rspec


