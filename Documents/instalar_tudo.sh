if [ "$EUID" -ne 0 ]; then 
	echo "Please run as root"
	exit
fi

#############################################################################
# Instala todos os packages
#############################################################################

allPackages=(
"xubuntu-desktop"
"openssh-client"
"openssh-server"
"vim"
"default-jre"
"default-jdk"
"steam"
"spotify"
#"mysql-server"
"wget"
"build-essential"
"cowsay"
)

for pkg in ${allPackages[@]}; do
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg |grep "install ok installed")
	echo Checking for $pkg: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	  echo "No $pkg. Setting up $pkg."
	  sudo apt-get --yes install $pkg 
	fi
done

#############################################################################
# Instala todos os .deb
#############################################################################


allDebs=(
"discord"
"minecraft-launcher"
"gitkraken"
)

for pkg in ${allDebs[@]}; do
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
	if [ "" = "$PKG_OK" ]; then

		##debs individuais
		if [ "discord" == $pkg ]; then wget -O ~/$pkg.deb "https://discordapp.com/api/download?platform=linux&format=deb"; fi
		if [ "minecraft-launcher" == $pkg ]; then wget -O ~/$pkg.deb "https://launcher.mojang.com/download/Minecraft.deb"; fi
		if [ "gitkraken" == $pkg ]; then wget -O ~/$pkg.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb"; fi
	fi
	echo Checking for $pkg: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	  echo "No $pkg. Setting up $pkg."
	  sudo dpkg -i $pkg.deb
	fi
done

#############################################################################
# Outros commandos
#############################################################################

# Precisa ter o .vimrc antes de chegar aqui
vim +'PlugInstall --sync' +qa || echo "vim +'PlugInstall --sync' +qa failed"

sudo systemctl enable ssh || echo "systemctl enable ssh failed"
sudo ufw allow ssh || echo "ufw allow ssh failed"

cowsay "Tudo pronto"
