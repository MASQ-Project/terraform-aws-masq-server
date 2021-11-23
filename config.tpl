#!/bin/bash
apt update -y
apt install -y jq awscli python
if [ "${centralLogging}" = true ]
then
    echo "Enabling cloudwatch logs"
    curl https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O
    sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
    echo "${agent_config}" | base64 -d >> /home/ubuntu/amazon-cloudwatch-agent.json
else
    echo "Cloudwatch logs not enabled"
fi
curl -so /usr/local/bin/MASQNode https://d1amsfh5awdbez.cloudfront.net/x86_64-unknown-linux-gnu/cloud-nodes/MASQNode
chmod 755 /usr/local/bin/MASQNode
curl -so /usr/local/bin/masq https://d1amsfh5awdbez.cloudfront.net/x86_64-unknown-linux-gnu/cloud-nodes/masq
chmod 755 /usr/local/bin/masq
mkdir /home/ubuntu/masq
chmod 755 /home/ubuntu/masq
ip=$(dig +short myip.opendns.com @resolver1.opendns.com)
arr=( $(curl -s https://dev.api.masq.ai/nodes/${chain} | jq -r '.[].descriptor') )
printf -v joined '%s,' "$${arr[@]}"
echo "chain=\"${chain}\"" >> /home/ubuntu/masq/config.toml
echo "blockchain-service-url=\"${bcsurl}\"" >> /home/ubuntu/masq/config.toml
echo "clandestine-port=\"${clandestine_port}\"" >> /home/ubuntu/masq/config.toml
echo "db-password=\"${dbpass}\"" >> /home/ubuntu/masq/config.toml
echo "dns-servers=\"${dnsservers}\"" >> /home/ubuntu/masq/config.toml
#echo "earning-wallet=\"${earnwallet}\"" >> /home/ubuntu/masq/config.toml
echo "gas-price=\"${gasprice}\"" >> /home/ubuntu/masq/config.toml
echo "ip=\"$${ip}\"" >> /home/ubuntu/masq/config.toml
echo "log-level=\"trace\"" >> /home/ubuntu/masq/config.toml
echo "neighborhood-mode=\"standard\"" >> /home/ubuntu/masq/config.toml
echo "real-user=\"1000:1000:/home/ubuntu\"" >> /home/ubuntu/masq/config.toml
if [ -z "$${arr}" ]
then
    echo "starting bootstrapped."
else
    echo "neighbors=\"$${joined%,}\"" >> /home/ubuntu/masq/config.toml
fi
#echo "consuming-private-key=\"${conkey}\"" >> /home/ubuntu/masq/config.toml
chown ubuntu:ubuntu /home/ubuntu/masq/config.toml
chmod 755 /home/ubuntu/masq/config.toml
echo "[Unit]" >> /etc/systemd/system/MASQNode.service
echo "Description=MASQNode serve" >> /etc/systemd/system/MASQNode.service
echo "After=network.target" >> /etc/systemd/system/MASQNode.service
echo "StartLimitIntervalSec=0" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Service]" >> /etc/systemd/system/MASQNode.service
echo "Type=simple" >> /etc/systemd/system/MASQNode.service
echo "Restart=always" >> /etc/systemd/system/MASQNode.service
echo "RestartSec=1" >> /etc/systemd/system/MASQNode.service
echo "User=ubuntu" >> /etc/systemd/system/MASQNode.service
echo "ExecStart=sudo /usr/local/bin/MASQNode --data-directory /home/ubuntu/masq" >> /etc/systemd/system/MASQNode.service
echo "" >> /etc/systemd/system/MASQNode.service
echo "[Install]" >> /etc/systemd/system/MASQNode.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/MASQNode.service
systemctl enable MASQNode.service
systemctl start MASQNode.service
sleep 2s
sudo chown ubuntu:ubuntu /home/ubuntu/.local/share/MASQ/"${chain}"
sleep 5s
/usr/local/bin/masq set-password "${dbpass}"
/usr/local/bin/masq recover-wallets --consuming-path "m/44'/60'/0'/0/0" --db-password "${dbpass}" --mnemonic-phrase "${mnemonic}" --earning-path "m/44'/60'/0'/0/0"
amazon-cloudwatch-agent-ctl -a fetch-config -s -m ec2 -c file:/home/ubuntu/amazon-cloudwatch-agent.json
echo "done"