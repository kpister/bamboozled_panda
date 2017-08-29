
# Bamboozled Panda

A simple ruby gem wrapper for the pandapay.io api

Be sure to set up your account with them first. You will need a private key, and a source token

Right now you can create a donation and create a grant.

# To use:

``` ruby
require 'bamboozled_panda'


BamboozledPanda::create_donation(50000, #amount in cents
                                 'source_token', #credit card or ach token from pandapay tokenizer
                                 'receipt@email.com', #receipt email for tax refund
                                 'sk_live_key' #secret key from pandapay
                                 ) # This will return [response_code, response_body]
                                 
BamboozledPanda::create_grant(2000, #amount in cents 
                              'charity_eid', #the tax id of the charity
                              'sk_live_key' #secret key from pandapay
                              ) # This will return [response_code, response_body]
```

This is version 0.0.1, and we will add more as we go!

Panda Pay takes: 

                1% + 2.9% + 30c per donation from credit/debit card donations
                1% + 25c        per donation from ACH donations, but to get this we need to talk to them more
