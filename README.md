
# Bamboozled Panda

A simple ruby gem wrapper for the pandapay.io api

Be sure to set up your account with them first. You will need a private key, and a source token

For some more information: [The Panda Pay 'docs'](http://docs.pandapay.io/getting-started-pandapay-api/api-reference)

# Usage:

```ruby
# To create some stuff...

require 'bamboozled_panda'


# PLEASE NOTE: credit card tokens are valid for a single donation unless you create a customer

# All response bodies are JSON format

BamboozledPanda::create_donation(50000, #amount in cents
                                 'source_token', #credit card, ach, or customer token from pandapay tokenizer 
                                 'receipt@email.com', #receipt email for tax refund
                                 'sk_live_key' #secret key from pandapay
                                 ) # This will return {code: response_code, body: response_body} 
                                 
BamboozledPanda::create_grant(2000, #amount in cents 
                              'charity_eid', #the tax id of the charity
                              'sk_live_key' #secret key from pandapay
                             ) # This will return {code: response_code, body: response_body} 

BamboozledPanda::create_customer(email@account.com, #your email account
                                 'source_token', #this is a recurring credit card or ach token rom pandapay
                                 'secret_token' #secret key from pandapay
                                ) # This will return {code: response_code, body: response_body} 

```

```ruby
# To get some stuff...

require 'bamboozled_panda'

BamboozledPanda::get_customers('secret_token') # return a list of your customer objects

BamboozledPanda::get_grants('secret_token') # return a list of your grants

BamboozledPanda::get_donations('secret_token') # return a list of your donations

BamboozledPanda::get_available_funds('secret_token') # return the current funds available to make grants with

```

```json
# example response

{:code=>"200", :body=>{"object"=>"list", "url"=>"/v1/customers", "has_more"=>false, "data"=>[{"id"=>"cus_2PfOqGFHDJ...", "object"=>"customer", "email"=>"pandapay@gmail.com", "livemode"=>true, "cards"=>[{"id"=>"card_Buv...", "object"=>"card", "created"=>1503964106, "livemode"=>true, "customer"=>"cus_2PfOqGFHDJ...", "last4"=>"20XX"}]}, {"id"=>"cus_AxdtGz5...", "object"=>"customer", "email"=>"kaiser@ethn.io", "livemode"=>true, "cards"=>[{"id"=>"card_LuYUF4z46...", "object"=>"card", "created"=>1503959644, "livemode"=>true, "customer"=>"cus_AxdtGz5...", "last4"=>"20XX"}]}]}}
```

This is version 0.0.3, and we will add more as we go!

Panda Pay takes: 

                1% + 2.9% + 30c per donation from credit/debit card donations
                1% + 25c        per donation from ACH donations, but to get this we need to talk to them more
