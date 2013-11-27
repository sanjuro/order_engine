require 'openssl'
require 'digest/md5'
require 'base64'
require 'savon'

module StandardBankHelper
  
  @@STANDARD_BANK_CHANNEL_NAME = "VOSTO"
  @@STANDARD_BANK_PASSWORD = "V0s70"
  @@STANDARD_BANK_KEY = "123456789123456789123456"
  @@STANDARD_BANK_WSDL_URL = "http://poc.beyondpayments.com/vostoapi/Service.asmx?WSDL"

  def create_channel_session   

    request_time = Time.now
    request_time_conveted = request_time.strftime("%Y-%m-%dT%H:%M:%S")
    request_time_sequence = request_time.strftime("%Y%m%d%H%M%S")
    channel_token = encrypt(@@STANDARD_BANK_KEY, @@STANDARD_BANK_PASSWORD)
    channel_last_sequence = convert_sequence("#{@@STANDARD_BANK_CHANNEL_NAME}:#{request_time_sequence}:#{@@STANDARD_BANK_KEY}")
    foreign_reference_key = generate_order_number

    # Setting up a Savon::Client representing a SOAP service.
    client = Savon.client do
      wsdl @@STANDARD_BANK_WSDL_URL
    end

    # Executing a SOAP request to call a "CreateChannelSession" action.
    begin

      message = {
        :credentials => {
              "ChannelName"  => @@STANDARD_BANK_CHANNEL_NAME,
              "ChannelToken"  => channel_token,
              "ChannelLastSequence"  => channel_last_sequence,   
              "ClientDateTime" => request_time_conveted,
              "ForeignReferenceKey" => foreign_reference_key,
              "KeySerialNumber" => "NULL"
        }
      }

      response = client.call(:create_channel_session, message: message)

    rescue Savon::SOAPFault => fault
      fault_code = error.to_hash[:fault][:faultcode]
      p fault_code
      raise
    end

    # convert reposne hash to array
    key_serial_number = response.to_hash[:create_channel_session_response][:create_channel_session_result][:key_serial_number]
    session_key = response.to_hash[:create_channel_session_response][:create_channel_session_result][:session_key]

    new_session = Hash.new
    new_session = { 
                    :key_serial_number => key_serial_number, 
                    :session_key => decrypt(@@STANDARD_BANK_KEY,session_key), 
                    :credentials => {
                          :ChannelLastSequence  => channel_last_sequence,   
                          :ClientDateTime => request_time_conveted,
                          :ForeignReferenceKey => foreign_reference_key
                    }
                  }

    return new_session
  end  

  def register_card(session_data, transaction_options)

    channel_token = encrypt(session_data[:session_key], @@STANDARD_BANK_PASSWORD)
    plain_card_info = "#{transaction_options[:card_number]}:#{transaction_options[:card_exp_date]}:#{transaction_options[:card_cvv]}:#{transaction_options[:card_holder_name]}"
    hash_value = convert_sequence(plain_card_info)

    encrypted_card_info = encrypt(session_data[:session_key], plain_card_info)
    encrypted_hash_value = encrypt(session_data[:session_key], hash_value)

    # p "Sessoin Key: #{session_data[:session_key]}" 
    # p "Plain Card Info: #{plain_card_info}"
    # p "Plain Hash: #{hash_value}"
    # p "Encrypted Card Info: #{encrypted_card_info}"
    # p "Encrypted Hash: #{encrypted_hash_value}"

    # Setting up a Savon::Client representing a SOAP service.
    client = Savon.client do
      wsdl @@STANDARD_BANK_WSDL_URL
    end
  
    # Executing a SOAP request to call a "GenerateSecurePin" action.
    begin

      message = {
        :credentials => {
              "ChannelName"  => @@STANDARD_BANK_CHANNEL_NAME,
              "ChannelToken"  => channel_token,
              "ChannelLastSequence"  => session_data[:credentials][:ChannelLastSequence],   
              "ClientDateTime" => session_data[:credentials][:ClientDateTime],  
              "ForeignReferenceKey" => session_data[:credentials][:ForeignReferenceKey],
              "KeySerialNumber" => session_data[:key_serial_number]
        },
        "HashValue" => encrypted_hash_value,
        "UniqueIdentifier" => transaction_options[:device_identifier],
        "CardInfo" => encrypted_card_info
      }

      response = client.call(:register_card, message: message)

    rescue Savon::SOAPFault => error
      fault_code = error.to_hash[:fault][:faultcode]
      p fault_code
      raise
    end

    # convert reposne hash to array
    secured_card_info = response.to_hash[:register_card_response][:register_card_result][:secured_card_info]
    decrypted_secured_card_info = decrypt(session_data[:session_key],secured_card_info)

    return_data = Hash.new
    return_data = {
                    :hash_value => hash_value,
                    :secured_card_info => decrypted_secured_card_info,
                  }
  end

  def start_payment_process(session_data, transaction_options)

    channel_token = encrypt(session_data[:session_key], @@STANDARD_BANK_PASSWORD)

    # Setting up a Savon::Client representing a SOAP service.
    client = Savon.client do
      wsdl @@STANDARD_BANK_WSDL_URL
    end

    # Executing a SOAP request to call a "CreateChannelSession" action.
    begin

      message = {
        :credentials => {
              "ChannelName"  => @@STANDARD_BANK_CHANNEL_NAME,
              "ChannelToken"  => channel_token,
              "ChannelLastSequence"  => session_data[:credentials][:ChannelLastSequence],   
              "ClientDateTime" => session_data[:credentials][:ClientDateTime],  
              "ForeignReferenceKey" => session_data[:credentials][:ForeignReferenceKey],
              "KeySerialNumber" => session_data[:key_serial_number]
        },
        "paymentType" => transaction_options[:payment_type],
        "amount" => transaction_options[:amount],
        "IDNumber" => "8112045070088",
        "MerchantId" => transaction_options[:merchant_id]
      }
      p "begin start_payment_process"
      response = client.call(:start_payment_process, message: message)
      p "end start_payment_process"
    rescue Savon::SOAPFault => fault
      fault_code = error.to_hash[:fault][:faultcode]
      p fault_code
      raise
    end

    # convert reposne hash to array
    payment_guid = response.to_hash[:start_payment_process_response][:start_payment_process_result][:payment_guid]
    result_text = response.to_hash[:start_payment_process_response][:start_payment_process_result][:result_text]

    return_data = Hash.new
    return_data = {
                    :payment_guid => payment_guid,
                    :result_text => result_text
                  }
  end  

  def complete_payment_process(session_data, transaction_options)

    channel_token = encrypt(session_data[:session_key], @@STANDARD_BANK_PASSWORD)

    hash_value = transaction_options[:card_hash]
    encrypted_hash_value = encrypt(session_data[:session_key], hash_value)

    card_info = transaction_options[:encrypted_card_info]
    encrypted_card_info = encrypt(session_data[:session_key], card_info)

    # p "Session Key: #{session_data[:session_key]}"
    # p "EncryptedCardInfo: #{card_info}"
    # p "CardHash: #{hash_value}"

    # p "Encrypted EncryptedCardInfo: #{encrypted_card_info}"
    # p "Encrypted CardHash: #{encrypted_hash_value}"

    # Setting up a Savon::Client representing a SOAP service.
    client = Savon.client do
      wsdl @@STANDARD_BANK_WSDL_URL
    end

    # Executing a SOAP request to call a "CreateChannelSession" action.
    begin

      message = {
        :credentials => {
              "ChannelName"  => @@STANDARD_BANK_CHANNEL_NAME,
              "ChannelToken"  => channel_token,
              "ChannelLastSequence"  => session_data[:credentials][:ChannelLastSequence],   
              "ClientDateTime" => session_data[:credentials][:ClientDateTime],  
              "ForeignReferenceKey" => session_data[:credentials][:ForeignReferenceKey],
              "KeySerialNumber" => session_data[:key_serial_number]
        },
        "GUID" => transaction_options[:guid],
        :card_info => {
            "EncryptedCardInfo" => encrypted_card_info,
            "CardHash" => encrypted_hash_value
        }

      }

      response = client.call(:complete_payment_process, message: message)

    rescue Savon::SOAPFault => fault
      fault_code = error.to_hash[:fault][:faultcode]
      p fault_code
      raise
    end

    # convert reposne hash to array
    result_text = response.to_hash[:complete_payment_process_response][:complete_payment_process_result][:result_text]

  end


  def encrypt(key, data)
    cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
    cipher.encrypt
    input = data
    cipher.key = key

    result = cipher.update(input) + cipher.final    
    encoded = Base64.encode64(result).encode('utf-8')
    encoded.strip 
  end

  def decrypt(key, data)

    # 10a9972c-8ede-4684-b25d-
    # data1 = 'sdBN1bb6vK9uUm6owdY/TlfgOJbtgNe585ch//R0cAk='

    # ea6a0186-5321-402c-858d-
    # data1 = "9SBY2rfJ+c2p9zixj0CisbYVzsnhYVLO85ch//R0cAk="

    data_decoded = Base64.decode64(data)

    # Effectively the same as the `encrypt` method
    cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
    cipher.decrypt # Also must be called before anything else
    cipher.padding = 0
    cipher.key = key

    result = cipher.update(data_decoded) 
    result << cipher.final   

    result.gsub(/[\b]/, '')
  end

  def convert_sequence(data)
    result = Digest::MD5.hexdigest(data)
    result_base64 = hex_to_base64_digest(result);
  end

  def hex_to_base64_digest(hexdigest)
    [[hexdigest].pack("H*")].pack("m0")
  end

  def to_hex(base64)
    base64.unpack("m0").first.unpack("H*").first
  end

  def generate_order_number
    random = "R#{Array.new(9){rand(9)}.join}"
  end

end