# frozen_string_literal: true

require 'viacep'

class ViaCepService
  def self.call(zip_code)
    new(zip_code).check_zip_code
  end

  private_class_method :new

  def initialize(zip_code)
    @zip_code = zip_code.to_s
  end

  def check_zip_code
    result = false

    circuit.run(circuitbox_exceptions: false) do
      result = ViaCep::Address.new(@zip_code, timeout: 1).is_a? ViaCep::Address
    end

    result
  end

  private

  def circuit
    @circuit ||= Circuitbox.circuit(:viacep, {
      # exceptions circuitbox tracks for counting failures (required)
      exceptions:       [SocketError, Timeout::Error],

      # seconds the circuit stays open once it has passed the error threshold
      sleep_window:     10,

      # length of interval (in seconds) over which it calculates the error rate
      time_window:      2,

      # number of requests within `time_window` seconds before it calculates error rates (checked on failures)
      volume_threshold: 1,

      # exceeding this rate will open the circuit (checked on failures)
      error_threshold:  5,

      # Logger to use
      logger: Logger.new(STDOUT)
    })
  end
end
