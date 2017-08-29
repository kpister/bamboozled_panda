require 'net/http'
require 'uri'

module BamboozledPanda 

  # Panda Pay takes 1% + 2.9% + 30c per donation from credit/debit card donations
  #                 1% + 25c        per donation from ACH donations, but to get this we need to talk to them more

  # this is used to create a "pool" of money from which we will take when using `transfer_to_grant`
  def self.create_donation(amount, source, email, secret_key) 
    uri = URI.parse("https://api.pandapay.io/v1/donations")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(secret_key, '')
    request.set_form_data(
      "amount" => amount,
      "currency" => "usd",
      "source" => source,
      "receipt_email" => email
    )

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    [response.code, response.body]
  end

  # I used the id of the California Community College Charity by default
  # This is where we actually send money to a charity
  # PandaPay does not send an email after this function
  def self.create_grant(amount, charity_id = "68-0412350", secret_key)
    uri = URI.parse("https://api.pandapay.io/v1/grants")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(secret_key, '')
    request.set_form_data(
      "amount" => amount,
      "destination" => charity_id
    )

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    [response.code, response.body]
  end
end
