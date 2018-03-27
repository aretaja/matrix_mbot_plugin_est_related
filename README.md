# matrix_mbot_plugin_est_related
Matrix Mbot plugins. Adds some plugins related to Estonia

## Getting Started
Installation on Debian

### Prerequisites
* From https://github.com/aretaja/matrix_mbot
Mbot

* From debian repo
```
apt install libxml-smart-perl
```
## Installing
### Install plugin
```
git clone https://github.com/aretaja/matrix_mbot_plugin_est_related
cd matrix_mbot_plugin_est_related
perl Makefile.PL
make
sudo make install
make clean
```

### Restart mbot
```
sudo systemctl restart mbot
```

## Usage
Ask help from bot
```
Mbot: help
```
