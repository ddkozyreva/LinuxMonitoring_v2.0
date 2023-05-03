##### System update #####
sudo apt-get update
sudo apt-get upgrade


##### Grafana installation #####
sudo dpkg -i grafana-enterprise_9.5.1_amd64.deb
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server


##### Prometheus installation #####
sudo apt-get install prometheus
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus


##### Node_exporter installation #####
tar xvf node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
sudo cp node_exporter /usr/local/bin
cd ..
rm -rf ./node_exporter-1.3.1.linux-amd64

sudo useradd --no-create-home --shell /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

cp node_exporter.service /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter

##### Stress-test #####
stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s