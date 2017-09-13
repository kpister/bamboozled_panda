require 'json'
require 'net/http'
require 'uri'

module BamboozledPanda 

  # Panda Pay takes 1% + 2.9% + 30c per donation from credit/debit card donations
  #                 1% + 25c        per donation from ACH donations, but to get this we need to talk to them more

  def self.set_key(secret_key)
    @secret_key = secret_key
  end

  # this is used to create a "pool" of money from which we will take when using `transfer_to_grant`
  def self.create_donation(amount, source, email)
    raise "Must set secret key with set_key" unless @secret_key

    uri = URI.parse("https://api.pandapay.io/v1/donations")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@secret_key, '')
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

    {code: response.code, body: JSON.parse(response.body)}
  end

  # I used the id of the California Community College Charity by default
  # This is where we actually send money to a charity
  # PandaPay does not send an email after this function
  def self.create_grant(amount, charity_id = "68-0412350")
    raise "Must set secret key with set_key" unless @secret_key

    uri = URI.parse("https://api.pandapay.io/v1/grants")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@secret_key, '')
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

    {code: response.code, body: JSON.parse(response.body)}
  end

  def self.create_customer(email, source_token)
    raise "Must set secret key with set_key" unless @secret_key

    uri = URI.parse("https://api.pandapay.io/v1/customers")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@secret_key, '')
    request.set_form_data(
      "email" => email,
      "source" => source 
    )

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    {code: response.code, body: JSON.parse(response.body)}
  end

  def self.get(resource)
    raise "Must set secret key with set_key" unless @secret_key

    uri = URI.parse("https://api.pandapay.io/v1/#{resource}")
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@secret_key, '')

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response
  end

  def self.get_customers
    customers = get('customers')
    {code: customers.code, body: JSON.parse(customers.body)}
  end

  def self.get_grants
    grants = get('grants')
    {code: grants.code, body: JSON.parse(grants.body)}
  end

  def self.get_donations
    donations = get('donations')
    {code: donations.code, body: JSON.parse(donations.body)}
  end

  def self.get_available_funds
    balance = get('balance')
    (JSON.parse(balance.body))["total_unallocated_donations_amount"]
  end
end
