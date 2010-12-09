net-ntp
=======

  Originally by Jerome Waibel in 2007  
  http://rubyforge.org/projects/net-ntp/

  Revised by Zencoder in 2010  
  http://github.com/zencoder/net-ntp

DESCRIPTION
-----------

  Began as a 'Rubyfied' version of perl's Net::NTP module, (C) 2004 by James G. Willmore. Refactored and re-released in 2010 by Zencoder.

SYNOPSIS
--------

    require 'net/ntp'

    Net::NTP.get("us.pool.ntp.org") # => a Net::NTP::Response object
    Net::NTP.get.time               # => A Time object

INSTALL
-------

    gem install net-ntp
