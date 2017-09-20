
# Bamboozled Panda

A simple ruby gem wrapper for the pandapay.io api.

Be sure to set up your account with them first. You will need a private key, and a source token.

For some more information: [The Panda Pay docs](http://docs.pandapay.io/getting-started-pandapay-api/api-reference)

# Usage:

First visit Pandapay.io, sign up for a developer account and enter the dashboard.

Then create a payment token using the tokenizer.html template. Just input your public key and your js src from your dashboard.

You can use this link. You will need to provide your publishable key and then open the js console. [tokenizer.html](https://rawgit.com/kpister/bamboozled_panda/master/tokenizer.html)

Use that payment token directly or create a customer for recurring use. Note that the payment token will expire after a single use unless you attach it to a customer object. 

With the payment/source token and your secret key you can make any calls you want.


```ruby
# To create some stuff...

require 'bamboozled_panda'

BamboozledPanda.set_key('private_key_here')

# PLEASE NOTE: credit card tokens are valid for a single donation unless you create a customer

# All response bodies are JSON format

BamboozledPanda.create_donation(50000, #amount in cents
                                 'source_token', #credit card, ach, or customer token from pandapay tokenizer 
                                 'receipt@email.com', #receipt email for tax refund
                                 'destination-ein' # OPTIONAL, if set: this will create an immediate grant object for the given charity
                                 ) # This will return {code: response_code, body: response_body} 

# Examples:

# Create a donation without a destination. This will be used later when we create a grant.
BamboozledPanda.create_donation(50000, 'sk_live_asdfasfasdf', 'kpister@github.com')

# Create a donation with a destination. This immediately creates a connected grant.
BamboozledPanda.create_donation(50000, 'sk_live_asdfasfasdf', 'kpister@github.com', '68-12312323')

BamboozledPanda.create_grant(2000, #amount in cents 
                              'charity_eid' #the tax id of the charity
                             ) # This will return {code: response_code, body: response_body} 

BamboozledPanda.create_customer(email@account.com, #your email account
                                 'source_token' #this is a recurring credit card or ach token from pandapay
                                ) # This will return {code: response_code, body: response_body} 

```

```ruby
# To get some stuff...

require 'bamboozled_panda'

BamboozledPanda.set_key('private_key_here')

# return a list of your customer objects
BamboozledPanda.get_customers


# return a list of your grants
BamboozledPanda.get_grants


# return a list of your donations
BamboozledPanda.get_donations


# return the current funds available to make grants with
BamboozledPanda.get_available_funds

```

```ruby
# example response

{
  :code=>"200", 
  :body=>{"object"=>"list", "url"=>"/v1/customers", "has_more"=>false, 
    "data"=>[
      {"id"=>"cus_2PfOqGF...", "object"=>"customer", "email"=>"pandapay@gmail.com", "livemode"=>true, 
        "cards"=>[
          {"id"=>"card_Buv...", "object"=>"card", "created"=>1503964106, "livemode"=>true, "customer"=>"cus_2PfOqGF...", "last4"=>"20XX"}
        ]
      }, 
      {"id"=>"cus_AxdtGz5...", "object"=>"customer", "email"=>"kaiser@ethn.io", "livemode"=>true, 
        "cards"=>[
          {"id"=>"card_LuY...", "object"=>"card", "created"=>1503959644, "livemode"=>true, "customer"=>"cus_AxdtGz5...", "last4"=>"20XX"}
        ]
      }
    ]
  }
}
```

This is version 0.1.1, and we will add more as we go!

Panda Pay takes: 

                1% + 2.9% + 30c per donation from credit/debit card donations
                1% + 25c        per donation from ACH donations, but to get this you need to talk to them personally
