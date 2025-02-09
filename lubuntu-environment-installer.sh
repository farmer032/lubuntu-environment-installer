read -r -s -p "Enter your password: " sudoPassword

function CheckReturnCode() {
    local ret=$?
    if [ $ret == 0 ]; then
        echo "Command executed successfully"
    else
        echo "Command failed. Exit code: $ret"
        exit -1
    fi
}

function AptInstall() {
    local appName=$1
    echo "Installing $appName"
    echo $sudoPassword | sudo -S apt-get install $appName -y &> /dev/null
    CheckReturnCode
}

function SudoAptGetUpdate() {
    echo "Sudo apt-get update"
    echo $sudoPassword | sudo -S apt-get update &> /dev/null
    CheckReturnCode
}

function SnapInstall() {
    local appName=$1
    local mode=$2
    local distributionChannel=$3
    echo "Installing $appName"
    echo $sudoPassword | sudo -S snap install $appName $mode $distributionChannel &> /dev/null
    CheckReturnCode
}

function NightLight() {
    echo "Enable night light"
    redshift -O 3000 &> /dev/null
    # CheckReturnCode - wayland issue
}

function SudoAptGetUpgrade() {
    SudoAptGetUpdate
    echo "sudo apt-get upgrade"
    echo $sudoPassword | sudo -S apt-get upgrade &> /dev/null
    CheckReturnCode
}

echo
echo "Username: $(whoami)"
SudoAptGetUpdate

# Night Light
AptInstall redshift
AptInstall redshift-gtk

# Enable night light
NightLight

# Utils
AptInstall vim
AptInstall gedit
AptInstall git
AptInstall wget
AptInstall curl
AptInstall unzip

# PHP
AptInstall php-cli
AptInstall php-mbstring

# Java
AptInstall openjdk-21-jdk

# Intellij Idea Community
SnapInstall intellij-idea-community --classic --edge

# Golang
SnapInstall go --classic 

# VSCode & VSCodium
SudoAptGetUpdate
SnapInstall code --classic
SnapInstall codium --classic

# Browser & codecs
SudoAptGetUpdate
SnapInstall chromium
AptInstall ffmpeg

# Upgrade System
SudoAptGetUpgrade
