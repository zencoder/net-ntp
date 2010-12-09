require "test_helper"

class Net::NTP::NTPTest < Test::Unit::TestCase
  def test_response_methods
    result = Net::NTP.get("de.pool.ntp.org")

    assert result.leap_indicator
    assert result.leap_indicator_text
    assert result.version_number
    assert result.mode
    assert result.mode_text
    assert result.stratum
    assert result.stratum_text
    assert result.poll_interval
    assert result.precision
    assert result.root_delay
    assert result.root_dispersion
    assert result.reference_clock_identifier
    assert result.reference_clock_identifier_text.nil?
    assert result.reference_timestamp > 1179864677
    assert result.originate_timestamp > 1179864677
    assert result.receive_timestamp > 1179864677
    assert result.transmit_timestamp > 1179864677
    assert result.time.is_a?(Time)
  end
end
