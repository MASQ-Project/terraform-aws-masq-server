#!/bin/bash
echo "Starting" >> /home/ubuntu/debug.txt
echo "loglevel ${loglevel}" >> /home/ubuntu/debug.txt

apt update -y
apt install -y jq awscli python zip curl tmux
sudo ufw allow "${clandestine_port}"

if [ "${centralLogging}" = true ]
then
    echo "Enabling cloudwatch logs"
    curl https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    echo "${agent_config}" | base64 -d >> /home/ubuntu/amazon-cloudwatch-agent.json
else
    echo "Cloudwatch logs not enabled"
fi

curl -so /home/ubuntu/masqBin.zip ${downloadurl}
unzip /home/ubuntu/masqBin.zip -d /home/ubuntu/


if [[ -d "/home/ubuntu/generated" ]]
then
    mv /home/ubuntu/generated/bin/MASQNode /usr/local/bin/MASQNode
    mv /home/ubuntu/generated/bin/masq /usr/local/bin/masq
else
    mv /home/ubuntu/MASQNode /usr/local/bin/MASQNode
    mv /home/ubuntu/masq /usr/local/bin/masq
fi

sudo chmod 755 /usr/local/bin/MASQNode
sudo chmod 755 /usr/local/bin/masq
mkdir /home/ubuntu/masq
chmod 755 /home/ubuntu/masq/
rm -rf /home/ubuntu/generated/
rm /home/ubuntu/generated.tar.gz
rm /home/ubuntu/masqBin.zip
ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ "${centralNighbors}" = true ]
then
    arr=( $(curl -s https://dev.api.masq.ai/nodes/${chain} | jq -r '.[].descriptor') )
    printf -v joined '%s,' "$${arr[@]}"
fi

# >>> ZERO-HOP config.toml
echo "chain=\"${chain}\"" >> /home/ubuntu/masq/config.toml
echo "blockchain-service-url=\"${bcsurl}\"" >> /home/ubuntu/masq/config.toml
echo "clandestine-port=\"${clandestine_port}\"" >> /home/ubuntu/masq/config.toml
echo "db-password=\"${dbpass}\"" >> /home/ubuntu/masq/config.toml
echo "dns-servers=\"${dnsservers}\"" >> /home/ubuntu/masq/config.toml
echo "gas-price=\"${gasprice}\"" >> /home/ubuntu/masq/config.toml
echo "log-level=\"${loglevel}\"" >> /home/ubuntu/masq/config.toml
echo "neighborhood-mode=\"zero-hop\"" >> /home/ubuntu/masq/config.toml
echo "real-user=\"1000:1000:/home/ubuntu\"" >> /home/ubuntu/masq/config.toml


echo "3" >> /home/ubuntu/debug.txt                                    #DEBUG
chown ubuntu:ubuntu /home/ubuntu/masq/config.toml
chmod 755 /home/ubuntu/masq/config.toml
echo "[Unit]" >> /etc/systemd/system/MASQNode.service
echo "Description=MASQNode serve" >> /etc/systemd/system/MASQNode.service
echo "After=network.target" >> /etc/systemd/system/MASQNode.service
echo "StartLimitIntervalSec=0" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Service]" >> /etc/systemd/system/MASQNode.service
echo "Type=forking" >> /etc/systemd/system/MASQNode.service
echo "Restart=always" >> /etc/systemd/system/MASQNode.service
echo "RestartSec=10" >> /etc/systemd/system/MASQNode.service
echo "User=ubuntu" >> /etc/systemd/system/MASQNode.service
echo "ExecStart=/usr/bin/tmux new-session -d -s masq '/usr/bin/sudo /usr/local/bin/MASQNode --data-directory /home/ubuntu/masq'" >> /etc/systemd/system/MASQNode.service
echo "ExecStop=/usr/bin/tmux kill-session -t masq" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Install]" >> /etc/systemd/system/MASQNode.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/MASQNode.service

echo "4" >> /home/ubuntu/debug.txt                                     #DEBUG

systemctl enable MASQNode.service
systemctl start MASQNode.service
sleep 5s
/usr/local/bin/masq set-password "${dbpass}"


echo "6" >> /home/ubuntu/debug.txt                                     #DEBUG
if [ "${cycleDerivation}" = true ]
then
    walletIndex=$((${derivationIndex}+${index}))
    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/$${walletIndex}" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-path "m/44'/60'/0'/0/$${walletIndex}" #
else
    if [ "${earnwalletAddressindex}" -eq "0" ]
    then
    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/0" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-path "m/44'/60'/0'/0/0" #
    else
    /usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/1" --db-password "${dbpass}" --mnemonic-phrase "${mnemonicAddress}" --earning-address "${earnwalletAddress}"
    fi
fi


/usr/local/bin/masq shutdown
sleep 2s
systemctl stop MASQNode.service
sleep 5s

echo "Swaping Config.toml" >> /home/ubuntu/debug.txt                              #DEBUG
mv /home/ubuntu/masq/config.toml /home/ubuntu/masq/config.del

echo "chain=\"${chain}\"" >> /home/ubuntu/masq/config.toml
echo "blockchain-service-url=\"${bcsurl}\"" >> /home/ubuntu/masq/config.toml
echo "clandestine-port=\"${clandestine_port}\"" >> /home/ubuntu/masq/config.toml
echo "db-password=\"${dbpass}\"" >> /home/ubuntu/masq/config.toml
echo "dns-servers=\"${dnsservers}\"" >> /home/ubuntu/masq/config.toml
echo "gas-price=\"${gasprice}\"" >> /home/ubuntu/masq/config.toml
echo "ip=\"$${ip}\"" >> /home/ubuntu/masq/config.toml
echo "log-level=\"${loglevel}\"" >> /home/ubuntu/masq/config.toml
echo "neighborhood-mode=\"standard\"" >> /home/ubuntu/masq/config.toml
echo "real-user=\"1000:1000:/home/ubuntu\"" >> /home/ubuntu/masq/config.toml
if [ "${paymentThresholds}" != "" ]; then echo "payment-thresholds=\"${paymentThresholds}\"" >> /home/ubuntu/masq/config.toml ; fi
if [ "${scanIntervals}" != "" ]; then echo "scan-intervals=\"${scanIntervals}\"" >> /home/ubuntu/masq/config.toml ; fi
if [ "${ratePack}" != "" ]; then echo "rate-pack=\"${ratePack}\"" >> /home/ubuntu/masq/config.toml ; fi



if [ "${masterNode}" = true ]
then
    echo "#neighbors=\"\"" >> /home/ubuntu/masq/config.toml 
else
    if [ "${randomNighbors}" = true ]
    then
    count=0
    while
        neighbor=$(curl -s https://dev.api.masq.ai/randomnode/${nodeFinderChain}/${nodeFinderSuburb})
        count=$(($count+1))
    [[ $neighbor == "{\"error\":\"Could not retreive any nodes\"}" && $count -lt 10 ]]
    do true; done
    echo "RandomNeighbor $${neighbor}"  >> /home/ubuntu/debug.txt                              #DEBUG
    echo "neighbors=\"$${neighbor}\"" >> /home/ubuntu/masq/config.toml

    else
        if [ -z "$${arr}" ]
        then
            echo "starting bootstrapped."
        else
            echo "neighbors=\"$${joined%,}\"" >> /home/ubuntu/masq/config.toml
        fi
        if [ "${centralNighbors}" = false ]
        then
            if [ "${customnNighbors}" != "" ]
            then
                echo "neighbors=\"${customnNighbors}\"" >> /home/ubuntu/masq/config.toml
            else
                echo "#neighbors=\"${customnNighbors}\"" >> /home/ubuntu/masq/config.toml
            fi
        fi
    fi
fi


# >> Sleep timer on Random from 1 - 31 secconds
echo "Sleep..." >> /home/ubuntu/debug.txt
timer=$(shuf -i ${waitTime} -n1)
echo "Timer: $${timer}" >> /home/ubuntu/debug.txt
sleep $${timer}


echo "New Config.toml" >> /home/ubuntu/debug.txt                              #DEBUG

sleep 5s
systemctl start MASQNode.service
#amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/home/ubuntu/amazon-cloudwatch-agent.json
echo "Node Up" >> /home/ubuntu/debug.txt                              #DEBUG


sleep 15
su ubuntu
descr=$(masq descriptor | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*')
hostname >> /home/ubuntu/info.txt
echo "$${ip}" >> /home/ubuntu/info.txt
echo "$${descr}" | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*' >> /home/ubuntu/info.txt
echo "$${descr}" | grep -oE '[a-zA-Z0-9_.-]*@[0-9].*' >> /home/ubuntu/descriptor.txt
echo "curl --request POST 'https://dev.api.masq.ai/nodes' --header 'Content-Type: application/json' --data-raw '{\"chain\":\"${nodeFinderChain}\",\"suburb\":\"${nodeFinderSuburb}\",\"descriptor\":\"$${descr}\"}'" >> /home/ubuntu/saveDescriptor.sh
echo "curl --request DELETE 'https://dev.api.masq.ai/node'  --header 'Content-Type: application/json' --data-raw '{\"chain\":\"${nodeFinderChain}\",\"suburb\":\"${nodeFinderSuburb}\",\"descriptor\":\"$${descr}\"}'" >> /home/ubuntu/deleteDescriptor.sh
echo "10" >> /home/ubuntu/debug.txt



if [ "${pushDescriptor}" = true ]
then
    echo "11" >> /home/ubuntu/debug.txt
    chmod +x /home/ubuntu/saveDescriptor.txt
    ./home/ubuntu/saveDescriptor.txt
    echo "Saved Descriptor" >> /home/ubuntu/debug.txt                              #DEBUG
else
    echo "12" >> /home/ubuntu/debug.txt
    echo "Descriptor NOT Saved" >> /home/ubuntu/debug.txt                              #DEBUG
fi
echo "FIN" >> /home/ubuntu/debug.txt
  
