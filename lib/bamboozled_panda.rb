require 'json'
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

    {code: response.code, body: JSON.parse(response.body)}
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

    {code: response.code, body: JSON.parse(response.body)}
  end

  def self.create_customer(email, source_token, secret_key)
    uri = URI.parse("https://api.pandapay.io/v1/customers")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(secret_key, '')
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

  def self.get(resource, secret_key)
    uri = URI.parse("https://api.pandapay.io/v1/#{resource}")
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(secret_key, '')

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response
  end

  def self.get_customers(secret_key)
    customers = get('customers', secret_key)
    {code: customers.code, body: JSON.parse(customers.body)}
  end

  def self.get_grants(secret_key)
    grants = get('grants', secret_key)
    {code: grants.code, body: JSON.parse(grants.body)}
  end

  def self.get_donations(secret_key)
    donations = get('donations', secret_key)
    {code: donations.code, body: JSON.parse(donations.body)}
  end

  def self.get_available_funds(secret_key)
    donations = get('donations', secret_key)
    grants = get('grants', secret_key)

    total_donations = 0
    if donations.code == "200"
      donations_json = JSON.parse(donations.body)
      donations_json['data'].each do |donation|
        total_donations += donation['donation_after_fees']
      end
    end

    total_grants = 0
    if grants.code == "200"
      grants_json = JSON.parse(grants.body)
      grants_json['data'].each do |grant|
        total_grants += grant['amount'] if grant['status'] == 'pending'
      end
    end

    total_donations - total_grants
  end
end
