require 'socket'
require 'timeout'

module NET

  class NTP
  
    TIMEOUT = 60
    
    NTP_ADJ = 2208988800

    MODE = {
          0    =>    'reserved',
          1    =>    'symmetric active',
          2    =>    'symmetric passive',
          3    =>    'client',
          4    =>    'server',
          5    =>    'broadcast',
          6    =>    'reserved for NTP control message',
          7    =>    'reserved for private use'
    }
    
    STRATUM = {
          0    =>    'unspecified or unavailable',
          1    =>    'primary reference (e.g., radio clock)'
    }
    
    2.upto(15) do |i|
        STRATUM[i] = 'secondary reference (via NTP or SNTP)'
    end
    16.upto(255) do |i|
        STRATUM[i] = 'reserved'
    end
    
    STRATUM_ONE_TEXT = {
        'LOCL'  => 'uncalibrated local clock used as a primary reference for a subnet without external means of synchronization',
        'PPS'   => 'atomic clock or other pulse-per-second source individually calibrated to national standards',
        'ACTS'  => 'NIST dialup modem service',
        'USNO'  => 'USNO modem service',
        'PTB'   => 'PTB (Germany) modem service',
        'TDF'   => 'Allouis (France) Radio 164 kHz',
        'DCF'   => 'Mainflingen (Germany) Radio 77.5 kHz',
        'MSF'   => 'Rugby (UK) Radio 60 kHz',
        'WWV'   => 'Ft. Collins (US) Radio 2.5, 5, 10, 15, 20 MHz',
        'WWVB'  => 'Boulder (US) Radio 60 kHz',
        'WWVH'  => 'Kaui Hawaii (US) Radio 2.5, 5, 10, 15 MHz',
        'CHU'   => 'Ottawa (Canada) Radio 3330, 7335, 14670 kHz',
        'LORC'  => 'LORAN-C radionavigation system',
        'OMEG'  => 'OMEGA radionavigation system',
        'GPS'   => 'Global Positioning Service',
        'GOES'  => 'Geostationary Orbit Environment Satellite'
    }
    
    LEAP_INDICATOR = {
          0    =>     'no warning',
          1    =>     'last minute has 61 seconds',
          2    =>     'last minute has 59 seconds)',
          3    =>     'alarm condition (clock not synchronized)'
    }
    
    def NTP.frac2bin(frac)
        bin  = ''
        while ( bin.length < 32 ) 
            bin  += ( frac * 2 ).to_i.to_s
            frac = ( frac * 2 ) - ( frac * 2 ).to_i 
        end
        return bin
    end
    
    def NTP.bin2frac(bin)
        frac = 0
        bin.reverse.split("").each do |b|
            frac = ( frac + b.to_i ) / 2.0
        end
        return frac
    end
    
    def NTP.unpack_ip(stratum, tmp_ip)
        if(stratum < 2)
            ip = [tmp_ip].pack("H8").unpack("A4")
        else
            ipbytes=[tmp_ip].pack("H8").unpack("C4")
            ip = sprintf("%d.%d.%d.%d", ipbytes[0],
             ipbytes[1], ipbytes[2], ipbytes[3]
            )
        end
        return ip
    end
    
    private_class_method :frac2bin, :bin2frac, :unpack_ip

    public

      def NTP.get_ntp_response(host="pool.ntp.org", port="ntp")
      
        sock = UDPSocket.new
        sock.connect(host, port)
      
        client_time_send = Time.new.to_i
        client_localtime = client_time_send
        client_adj_localtime = client_localtime + NTP_ADJ
        client_frac_localtime = frac2bin(client_adj_localtime)
  
        ntp_msg =
          (['00011011']+Array.new(12, 0)+[client_localtime, client_frac_localtime.to_s]).pack("B8 C3 N10 B32")
  
        sock.print ntp_msg
        sock.flush
       
        data=NIL 
        Timeout::timeout(TIMEOUT) do |t|
          data=sock.recvfrom(960)[0]
        end
        client_time_receive = Time.new.to_i
        
        ntp_fields = %w{ byte1 stratum poll precision
         delay delay_fb disp disp_fb ident
         ref_time ref_time_fb
         org_time org_time_fb
         recv_time recv_time_fb
         trans_time trans_time_fb }
        
        packetdata =
            data.unpack("a C3   n B16 n B16 H8   N B32 N B32   N B32 N B32"); 
        
        tmp_pkt=Hash.new
        ntp_fields.each do |f|
          tmp_pkt[f]=packetdata.shift
        end
      
        packet=Hash.new
        packet['Leap Indicator']=(tmp_pkt['byte1'][0] & 0xC0) >> 6 
        packet['Version Number']=(tmp_pkt['byte1'][0] & 0x38) >> 3
        packet['Mode']=(tmp_pkt['byte1'][0] & 0x07)
        packet['Stratum']=tmp_pkt['stratum']
        packet['Poll Interval']=tmp_pkt['poll']
        packet['Precision']=tmp_pkt['precision'] - 255
        packet['Root Delay']=bin2frac(tmp_pkt['delay_fb'])
        packet['Root Dispersion']=tmp_pkt['disp']
        packet['Reference Clock Identifier']=unpack_ip(tmp_pkt['stratum'], tmp_pkt['ident'])
        packet['Reference Timestamp']=((tmp_pkt['ref_time'] + bin2frac(tmp_pkt['ref_time_fb'])) - NTP_ADJ)
        packet['Originate Timestamp']=((tmp_pkt['org_time'] + bin2frac(tmp_pkt['org_time_fb'])) )
        packet['Receive Timestamp']=((tmp_pkt['recv_time'] + bin2frac(tmp_pkt['recv_time_fb'])) - NTP_ADJ)
        packet['Transmit Timestamp']=((tmp_pkt['trans_time'] + bin2frac(tmp_pkt['trans_time_fb'])) - NTP_ADJ)
        
        return packet
      
      end
  
  end

end
