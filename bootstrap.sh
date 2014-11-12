#!/usr/bin/env bash

case $(id -u) in
    0)
		sudo apt-get update
		sudo apt-get install unzip -y
		sudo apt-get install python-software-properties -y
		sudo apt-get install curl -y
		curl -sL https://deb.nodesource.com/setup | sudo bash -
		sudo apt-get install -y nodejs
		sudo apt-get install git -y
		sudo dpkg --add-architecture i386
		sudo apt-get update
		sudo apt-get install libncurses5:i386 libstdc++6:i386 zlib1g:i386 -y
		sudo apt-get install openjdk-7-jdk -y
		gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
		curl -sSL https://get.rvm.io | bash -s stable --ruby
		source /home/vagrant/.rvm/scripts/rvm
		echo "export PATH=/home/vagrant/.rvm/scripts/rvm:$PATH" >> ~/.bashrc
		export PATH=/home/vagrant/.rvm/scripts/rvm:$PATH
		sudo -u vagrant -i $0
		;;
	*)
		## Ruby
		gem install --no-rdoc --no-ri bundler
		gem install --no-rdoc --no-ri appium_console
		gem cleanup
		
		##################################################################################################
		# Node
		##################################################################################################
		
		# Enable npm to be used without sudo
		npm config set prefix ~/npm
		npm install -g grunt grunt-cli
		# Add ~/npm/bin to the PATH variable
		echo "export PATH=$HOME/npm/bin:$PATH" >> ~/.bashrc
		export PATH=$HOME/npm/bin:$PATH
		# Execute the .bashrc file

		##################################################################################################
		# ADT
		##################################################################################################

		# Download ADT
		curl -O https://dl.google.com/android/adt/adt-bundle-linux-x86_64-20140702.zip 

		# Extract ADT archive 
		unzip adt-bundle-linux-x86_64-20140702.zip

		# Define new ANDROID_HOME env var inside .bashrc
		echo "export ANDROID_HOME=/home/vagrant/adt-bundle-linux-x86_64-20140702/sdk" >> ~/.bashrc
		export ANDROID_HOME="/home/vagrant/adt-bundle-linux-x86_64-20140702/sdk"
		# Add ~/npm/bin to the PATH variable               
		echo "export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH" >> ~/.bashrc
		# Execute the .bashrc file
		export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
		#./android update sdk -u  
		( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | ~/adt-bundle-linux-x86_64-20140702/sdk/tools/android update sdk -u -a --filter tools,platform-tools,build-tools-21.1.1,android-19,sys-img-x86-android-19
		
		##################################################################################################
		# Ant
		##################################################################################################

		# Download ant
		curl -O http://mirror.gopotato.co.uk/apache//ant/binaries/apache-ant-1.9.4-bin.tar.gz    

		# Extract ant
		tar -zxvf apache-ant-1.9.4-bin.tar.gz 

		# Add ant/bin to the PATH variable
		echo "export PATH=$HOME/apache-ant-1.9.4/bin:$PATH" >> ~/.bashrc
		# Execute the .bashrc file
		export PATH=$HOME/apache-ant-1.9.4/bin:$PATH

		##################################################################################################
		# Enable USB devices
		##################################################################################################

		# Samsung Galaxy
		sudo cp /vagrant/android.rules /etc/udev/rules.d/51-android.rules
		sudo chmod 644   /etc/udev/rules.d/51-android.rules
		sudo chown root. /etc/udev/rules.d/51-android.rules
		sudo service udev restart
		sudo killall adb
		
		##################################################################################################
		# Appium
		##################################################################################################

		# Clone Appium
		git clone https://github.com/appium/appium.git

		# Change to the appium directory
		cd appium

		# Reset appium
		# Running the reset.sh script doesn't seem to work correctly via the script.
		# This could be fixed with some TLC.
		#./reset.sh --android --verbose

		##################################################################################################
		# Launching VM 
		##################################################################################################

		echo "################################################################"
		echo "Bootstrap finished:"
		echo " > Please run 'vagrant ssh' to launch VM"
		echo "################################################################"

		##################################################################################################
		# Connecting USB devices 
		##################################################################################################

		echo "USB Device setup:"
		echo " > Please connect your device via USB"
		echo " > \$ANDROID_HOME/platform-tools/adb devices"
		echo "################################################################"

		##################################################################################################
		# Next steps... 
		##################################################################################################

		echo "Manual steps:"
		echo " > cd ~/appium"
		echo " > ./reset.sh --android"
		echo " > node ."

		;;
esac
