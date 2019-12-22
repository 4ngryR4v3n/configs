# Configs (my personal configuration files and their installer scripts)

## Usage

Use this on fresh installations (basically a typical post-install script).

```
git clone https://github.com/Perdyx/configs.git ~/.cfg
chmod +x ~/.cfg/installers/ubuntu.sh
~/.cfg/installers/ubuntu.sh
```

## Usage (standalone)

Use this if you want to only add the backup functionality.

```
sudo cp $home/$cfgdir/services/cfgbackup.service /etc/systemd/system/cfgbackup.service
sudo chmod 644 /etc/systemd/system/cfgbackup.service
sudo systemctl enable cfgbackup
```
