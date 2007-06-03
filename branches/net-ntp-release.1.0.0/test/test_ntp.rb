require "test/unit"
require "ntp"

class TestNTP < Test::Unit::TestCase
  def test_read_time
    ntpresult = NET::NTP::get_ntp_response("de.pool.ntp.org")
    # We should really be past this timestamp
    assert( ntpresult["Receive Timestamp"] > 1179864677 )
  end
end