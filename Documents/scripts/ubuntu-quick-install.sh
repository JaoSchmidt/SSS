#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then 
	echo "Please run as root"
	exit
fi
USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

#############################################################################
# Repostórios
#############################################################################
repos=$(find /etc/apt -name *.list | xargs cat | grep ^[[:space:]]*deb)
need_update=0
REPO_OK=$(echo $repos | grep spotify)
echo "Checking spotify repo"
if [ "" = "$REPO_OK" ]; then
	need_update=1
	echo "No spofify repository. Setting up spotify repo."
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
else
	echo "Ok already added"
fi

if [[ $need_update == 1 ]]; then
	sudo apt-get update
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
"git"
"nodejs"
#"mysql-server"
"spotify-client"
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
"steam"
)

for pkg in ${allDebs[@]}; do
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok")
	echo Checking for $pkg: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
		echo "No $pkg. Setting up $pkg."

		##debs individuais
		if [ "discord" == $pkg ]; then wget -O ~/$pkg.deb "https://discordapp.com/api/download?platform=linux&format=deb"; fi
		if [ "minecraft-launcher" == $pkg ]; then wget -O ~/$pkg.deb "https://launcher.mojang.com/download/Minecraft.deb"; fi
		if [ "gitkraken" == $pkg ]; then wget -O ~/$pkg.deb "https://release.gitkraken.com/linux/gitkraken-amd64.deb"; fi
		if [ "steam" == $pkg ]; then wget -O ~/$pkg.deb "http://repo.steampowered.com/steam/archive/precise/steam_latest.deb"; fi
		sudo dpkg -i ~/$pkg.deb
		rm ~/$pkg.deb
	fi
done

#plug-vim
if [ -e $USER_HOME/.vim/autoload/plug.vim ]; then
	curl -fLo $USER_HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
fi
#############################################################################
# Outros commandos
#############################################################################

## Comandos vim
# Precisa ter o .vimrc antes de chegar aqui
echo "configuring vim-plug"
vim +'PlugInstall --sync' +qa || echo "vim +'PlugInstall --sync' +qa failed"

## Commandos openssh
echo "enabling ssh"
sudo systemctl enable ssh || echo "systemctl enable ssh failed"
sudo ufw allow ssh || echo "ufw allow ssh failed"

## Comandos git
echo "set git user"
git config --global user.name "JaoSchmidt" || echo "add git username failed"
git config --global user.email "jhsc98@gmail.com" || echo "add git email failed"
#git config core.sparsecheckout true || echo "sparsecheckout failed"

## Comandos dwm
# move a sessão do dwm para pode ser usado no login ...
# supondo que o arq tenha sido pego do repositório
if [ -e $USER_HOME/dwm.desktop ]; then
	sudo mv $USER_HOME/dwm.desktop /usr/share/xsessions/
fi
runuser -l $SUDO_USER -c 'cowsay pronto'
