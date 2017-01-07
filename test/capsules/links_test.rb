require 'test_helper'
require 'omise'

class LinksTest < ActiveSupport::TestCase
  PAY_JP = "pay.jp"
  STRIPE = "stripe"
  OMISE  = "omise"

  KEYCHAIN = "config/keychain.dsl" 
  
  def list_to_hash(list, hash={})
    list.each {|x| hash[x[0]] = x[1]}
    hash
  end

  def key_chain_error_msg()
    """
       You need to create Keychain. 
       
       Follow the example:
       
        $vim #{KEYCHAIN}
        -----------------------------
        omise=skey_test_32.....
        
    """
  end

  def raise_if_key_absent()
    raise key_chain_error_msg if !File.exist?(KEYCHAIN)
  end

  def keychain_to_hash()
    raise_if_key_absent
    list_to_hash(File.read(KEYCHAIN).each_line.map{|line| line.chomp.split('=')})
  end

  def get_public_api_key(psp)
    keychain_to_hash[OMISE] if psp == OMISE
  end 

  def curl_url(psp)
    "curl https://api.omise.co/links" if psp == OMISE
  end

  def make_pair(head, tail)
     return " -#{head} \"#{tail[0]}=#{tail[1]}\"" if head == "d"
     return " -#{head} #{tail[0]}"                if head != "d"
  end

  def car(l)
    l.first
  end

  def cdr(l)
    l.shift
    l
  end

  def build_curl_params(curl, params)
    params.inject(curl) { |cmd, l| cmd + make_pair(car(l), cdr(l)) }
  end

  test "ass" do
    system build_curl_params(curl_url(OMISE), [
             %w(X POST), 
             ["u", get_public_api_key(OMISE)],
             %w(d amount 1000),
             %w(d currency thb),
             %w(d title aaaa),
             %w(d description AAA),
             %w(d multiple true)
           ])
  end

  test "create a link for one time use" do
    puts get_public_api_key(OMISE)
    
    Omise.api_key = get_public_api_key(OMISE)
    link = Omise::Link.create({
      amount: 99900,
      currency: "thb",
      title: "Hot Latte",
      description: "A warm cup of coffee",
    })
  end
end
