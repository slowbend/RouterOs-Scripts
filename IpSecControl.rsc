#First we need to prepare ChatId and Token for telegram
:local chatid "xxxxxx"
:local token "xxxxxxxx"


:local IpSecRemoteIP
:local ipSecDurumu
:local SantiyeAdi

:foreach ipSecIp in=[/ip ipsec peer find] do={
 :set IpSecRemoteIP [/ip ipsec peer get $ipSecIp address]
 :set IpSecRemoteIP [:pick $IpSecRemoteIP 0 [:find $IpSecRemoteIP "/"]]
 :set SantiyeAdi [/ip ipsec peer get $ipSecIp name]
 :foreach x in=[/ip ipsec active-peers find remote-address=$IpSecRemoteIP] do={:set ipSecDurumu [/ip ipsec active-peers get $x state]}
 :if ($ipSecDurumu != "established") do={
    :local message "\F0\9F\94\A5 $SantiyeAdi Santiyesinde IPSec Baglantisi koptu : $IpSecRemoteIP"
    :local url ("https://api.telegram.org/bot" . $token . "/sendMessage")
    :local postdata ("chat_id=" . $chatid . "&text=" . $message)

    /tool fetch url=$url mode=https http-method=post http-data=$postdata

:set ("$IpSecMesajGidenler"->$SantiyeAdi) "1"

  }

}