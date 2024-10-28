#!/bin/bash

#mkdir -p ./SmartDNS_chnlist
#sudo rm -rf ./SmartDNS_chnlist/*
#wget --show-progress -cqO- https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf | sed 's/server=/nameserver /g' | rev | cut -d / -f2- | rev | sed 's?$?/DNS_chn?g'>./SmartDNS_chnlist/accelerated-domains.china.conf
#wget --show-progress -cqO- https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf | sed 's/server=/nameserver /g' | rev | cut -d / -f2- | rev | sed 's?$?/DNS_chn?g'>./SmartDNS_chnlist/apple.china.conf
#
#cp -f IPchnroute ./SmartDNS_chnlist/whitelist-ip-chnlist.conf
#sed -i 's/^/whitelist-ip /g' ./SmartDNS_chnlist/whitelist-ip-chnlist.conf
#
#sha256sum ./SmartDNS_chnlist/accelerated-domains.china.conf | awk '{print$1}' >./SmartDNS_chnlist/accelerated-domains.china.conf.sha256sum
#sha256sum ./SmartDNS_chnlist/apple.china.conf | awk '{print$1}' >./SmartDNS_chnlist/apple.china.conf.sha256sum
#sha256sum ./SmartDNS_chnlist/whitelist-ip-chnlist.conf | awk '{print$1}' >./SmartDNS_chnlist/whitelist-ip-chnlist.conf.sha256sum



mkdir -p ./mosdns_chnlist
sudo rm -rf ./mosdns_chnlist/*

wget --show-progress -cqO /tmp/geosite.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geosite.dat
wget --show-progress -cqO /tmp/geoip.dat https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/geoip.dat
chmod +x mosdns


#解包中国域名
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:private
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:cn
wget --show-progress -cqO- https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf \
| cut -d / -f2 >/tmp/Domains.chn.txt
cat /tmp/geosite_private.txt \
/tmp/geosite_cn.txt \
/tmp/Domains.chn.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/Domains.chn.txt

# 解包中国IP列表
./mosdns v2dat unpack-ip -o /tmp /tmp/geoip.dat:cn
cat /tmp/geoip_cn.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/chn_ip.txt

# 解包Apple相关域名
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:apple
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:apple-cn
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:apple-ads
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:apple-dev
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:apple-update
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:icloud
cat /tmp/geosite_apple.txt \
/tmp/geosite_apple-cn.txt \
/tmp/geosite_apple-ads.txt \
/tmp/geosite_apple-dev.txt \
/tmp/geosite_apple-update.txt \
/tmp/geosite_icloud.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/Domains.apple.txt

./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:category-games
cat /tmp/geosite_category-games.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/Domains.games.txt

# 解包非中国域名
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:geolocation-!cn
cat /tmp/geosite_geolocation-!cn.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/no_cn_list.txt

# 微软相关域名
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:microsoft
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:microsoft-dev
./mosdns v2dat unpack-domain -o /tmp /tmp/geosite.dat:microsoft-pki
cat /tmp/geosite_microsoft.txt \
cat /tmp/geosite_microsoft-dev.txt \
cat /tmp/geosite_microsoft-pki.txt \
| sort | uniq | xargs -n1 | sed '/^\s*$/d' >./mosdns_chnlist/Domains.microsoft.txt

wget --show-progress -cqO ./mosdns_chnlist/99-bogus-nxdomain.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf
sha256sum ./mosdns_chnlist/99-bogus-nxdomain.china.conf | awk '{print$1}' >./mosdns_chnlist/99-bogus-nxdomain.china.conf.sha256sum

sha256sum ./mosdns_chnlist/Domains.chn.txt | awk '{print$1}' >./mosdns_chnlist/Domains.chn.txt.sha256sum
sha256sum ./mosdns_chnlist/Domains.apple.txt | awk '{print$1}' >./mosdns_chnlist/Domains.apple.txt.sha256sum
sha256sum ./mosdns_chnlist/Domains.games.txt | awk '{print$1}' >./mosdns_chnlist/Domains.games.txt.sha256sum
