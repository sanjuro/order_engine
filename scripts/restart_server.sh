sudo service god-service stop
sudo kill -9 `ps -ef | grep res | grep -v grep | awk '{print $2}'`
sudo kill -9 `ps -ef | grep 'ruby server.rb' | grep -v grep | awk '{print $2}'`
sudo service god-service start