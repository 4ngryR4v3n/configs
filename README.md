# Configs

## Usage

Use this on fresh installations (basically a typical post-install script).

```
git clone https://github.com/Perdyx/configs.git ~/.cfg
chmod +x ~/.cfg/installers/ubuntu.sh
~/.cfg/installers/ubuntu.sh
```

## Usage (standalone)

Use this if you want to only add the backup functionality (be sure to replace all instances of "USER" with your username).

```
git clone https://github.com/Perdyx/configs.git ~/.cfg
sudo cp ~/.cfg/services/cfgbackup.service /etc/systemd/system
sudo chmod +x ~/.cfg/services/cfgbackup.sh
sudo systemctl enable cfgbackup.service
```
