# net-ntp
    by Jerome Waibel
    http://rubyforge.org/projects/net-ntp/

    revised by Nathan Sutton
    http://github.com/zencoder/net-ntp

## DESCRIPTION:

Rubyfied version of perl's Net::NTP module, (C) 2004 by James G. Willmore.

This module exports a single method (NET::NTP::get_ntp_response) and returns a
hash based upon RFC1305 and RFC2030.

## FEATURES/PROBLEMS:

## SYNOPSIS:

    require 'net/ntp'

    Net::NTP.get("de.pool.ntp.org") # => a Net::NTP::Response object
    Net::NTP.get.time # => A Time object

## REQUIREMENTS:

== INSTALL:

* sudo gem install net-ntp

== LICENSE:

(The MIT License)

Copyright (c) 2007

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
