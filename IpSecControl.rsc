#First we need to prepare ChatId and Token for telegram
:local chatid "xxxxxx"
:local token "xxxxxxxx"

:local SantiyeIP
:local durum
:local SantiyeAdi
:local komment

:foreach t in=[/ip ipsec policy find active] do={
:set SantiyeIP [/ip ipsec peer get [find name=[/ip ipsec policy get $t value-name=peer]] address ]
:set SantiyeIP [:pick $SantiyeIP 0 [:find $SantiyeIP "/"]]
:set SantiyeAdi [/ip ipsec peer get [find name=[/ip ipsec policy get $t value-name=peer]] name ]
:set durum [/ip ipsec policy get $t ph2-state]
:set komment [/ip ipsec identity get [find peer=[/ip ipsec policy get $t value-name=peer]] comment]
:if ($durum != "established") do={
:local message "\F0\9F\94\A5 $SantiyeAdi Santiyesinde IPSec Baglantisi koptu : $SantiyeIP"
:local url ("https://api.telegram.org/bot" . $token . "/sendMessage")
:local postdata ("chat_id=" . $chatid . "&text=" . $message)
:if ($komment != "KESIK") do={/tool fetch url=$url mode=https http-method=post http-data=$postdata
    /ip ipsec identity set [find peer=[/ip ipsec policy get $t value-name=peer]] comment="KESIK"}
 } else={
:if ($komment = "KESIK") do={
/ip ipsec identity set [find peer=[/ip ipsec policy get $t value-name=peer]] comment=$SantiyeAdi
:local message "\F0\9F\91\8D $SantiyeAdi Santiyesinde IPSec BAGLANDI : $SantiyeIP"
:local url ("https://api.telegram.org/bot" . $token . "/sendMessage")
:local postdata ("chat_id=" . $chatid . "&text=" . $message)
/tool fetch url=$url mode=https http-method=post http-data=$postdata
}
}
}