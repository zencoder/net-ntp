require "test_helper"

class Net::NTP::NTPTest < Test::Unit::TestCase
  POOL = "de.pool.ntp.org"

  def setup
    @result_1 = Net::NTP.get(POOL)
    sleep 0.1
    @result_2 = Net::NTP.get(POOL)
  end

  def test_response_methods
    result = @result_1

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
    assert result.client_time_receive > 1179864677
  end

  def test_reasonably_increasing_response
    difference = @result_2.receive_timestamp - @result_1.receive_timestamp

    # Should be about 0.1 seconds, so check that it's at least 0.01
    assert difference > 0.01

    # Should be about 0.1 seconds, so check that it's not more than 0.5
    assert difference < 0.5, "Expected #{@result_2.receive_timestamp} to be about 0.1 more than #{@result_1.receive_timestamp}, but was #{difference}"
  end

  def test_offset
    ntpdate_output = `ntpdate -p1 -q #{POOL} 2>/dev/null`
    omit "ntpdate not available - cannot run this test right now" unless $?.success?

    if m = ntpdate_output.match(/offset (-?\d+\.\d+) sec/)
      expected = Float m[1]
      result = @result_1

      # Expect these offsets to be very close -- within 0.5 or 5% for test purposes.
      difference = (expected - result.offset).abs
      percentage = (result.offset.to_f / expected)

      if difference < 0.5
        # This is always fine.
        assert true
      elsif expected.abs < 0.0001
        # Avoiding issues with percentage on tiny numbers, but it's not a good output.
        assert false, "Offset was not within expected tolerance.  Expected #{expected} but got #{result.offset}."
      else
        assert (percentage > 0.95 && percentage < 1.05), "Offset was not within expected tolerance.  Expected #{expected} but got #{result.offset}."
      end
    else
      omit "ntpdate not parseable - cannot run this test right now"
    end
  end
end
