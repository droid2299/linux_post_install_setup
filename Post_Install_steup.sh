#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l | grep -w $1
}

# Function to install Visual Studio Code
install_vscode() {
    if ! is_installed code; then
        echo "Installing Visual Studio Code..."
        curl -o vscode.deb -L "https://go.microsoft.com/fwlink/?LinkID=760868"
        sudo dpkg -i vscode.deb
        sudo apt-get install -f
        rm vscode.deb
        echo "Visual Studio Code installation completed."
    else
        echo "Visual Studio Code is already installed."
    fi
}

# Function to install Spotify
install_spotify() {
    if ! is_installed spotify-client; then
        echo "Installing Spotify..."
        curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt-get update
        sudo apt-get install spotify-client
        echo "Spotify installation completed."
    else
        echo "Spotify is already installed."
    fi
}

# Function to install Brave Browser
install_brave() {
    if ! is_installed brave-browser; then
        echo "Installing Brave Browser..."
        sudo apt-get install apt-transport-https curl
        curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/brave-browser-release.gpg
        echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt-get update
        sudo apt-get install brave-browser
        echo "Brave Browser installation completed."
    else
        echo "Brave Browser is already installed."
    fi
}

# Function to install Docker
install_docker() {
    if ! is_installed docker-ce; then
        echo "Installing Docker..."
        sudo apt-get remove docker docker-engine docker.io containerd runc
        sudo apt-get update
        sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io
        echo "Docker installation completed."
    else
        echo "Docker is already installed."
    fi
}

# Function to install VLC
install_vlc() {
    if ! is_installed vlc; then
        echo "Installing VLC..."
        sudo apt-get update
        sudo apt-get install vlc
        echo "VLC installation completed."
    else
        echo "VLC is already installed."
    fi
}

# Function to download wallpaper and set it
set_wallpaper() {
    echo "Downloading wallpaper..."
    wget -O wallpaper.jpg "YOUR_GITHUB_RAW_IMAGE_LINK"
    gsettings set org.gnome.desktop.background picture-uri "file:///$(pwd)/wallpaper.jpg"
    echo "Wallpaper set successfully."
}

# Function to set Ubuntu dock to the bottom
set_dock_to_bottom() {
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
    num_icons=$(gsettings get org.gnome.shell.extensions.dash-to-dock dash-max-icon-size)
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size $num_icons
    echo "Ubuntu dock settings applied."
}

# Function to enable AirPods
enable_airpods() {
    # Check if the necessary packages are installed
    if ! dpkg -s pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-firmware > /dev/null 2>&1; then
        echo "Installing required packages..."
        sudo apt-get update
        sudo apt-get install pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-firmware
    fi

    # Enable PulseAudio Bluetooth module
    if ! grep -q "^load-module module-bluetooth-discover" /etc/pulse/default.pa; then
        echo "Enabling PulseAudio Bluetooth module..."
        echo "load-module module-bluetooth-discover" | sudo tee -a /etc/pulse/default.pa
        pulseaudio -k
    fi

    # Enable A2DP sink for AirPods
    echo "Switching AirPods profile to A2DP sink..."
    mac_address=$(bluetoothctl devices | grep -i "AirPods" | awk '{print $2}')
    if [ -n "$mac_address" ]; then
        bluetoothctl connect "$mac_address"
        pacmd set-card-profile bluez_card."$mac_address" a2dp_sink
        echo "AirPods connected and set as audio output."
    else
        echo "AirPods not found. Make sure they are in pairing mode and try again."
    fi
}

# Function to install anaconda and setup a basic deep learning env
install_deep_learning_env() {
    # Define the Anaconda installer filename
    anaconda_installer="Anaconda3-2021.05-Linux-x86_64.sh"

    # Check if Anaconda is already installed
    if command -v conda &>/dev/null; then
        echo "Anaconda is already installed. Skipping installation."
    else
        # Download Anaconda installer
        if [ ! -f "$anaconda_installer" ]; then
            echo "Downloading Anaconda installer..."
            wget "https://repo.anaconda.com/archive/$anaconda_installer"
        fi

        # Install Anaconda
        echo "Installing Anaconda..."
        bash "$anaconda_installer" -b -p "$HOME/anaconda3"
        rm "$anaconda_installer"

        # Initialize conda in the current shell
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
        conda activate

        # Add conda initialization to .bashrc or .bash_aliases if not already there
        if ! grep -q "conda.sh" "$HOME/.bashrc" && ! grep -q "conda.sh" "$HOME/.bash_aliases"; then
            echo "Adding conda initialization to .bashrc"
            echo ". '$HOME/anaconda3/etc/profile.d/conda.sh'" >> "$HOME/.bashrc"
            echo "conda activate" >> "$HOME/.bashrc"
        fi
    fi

    # Create a new conda environment for deep learning
    echo "Creating a new conda environment for deep learning..."
    conda create -n deep_learning_env python=3.8

    # Activate the deep learning environment
    echo "Activating deep_learning_env..."
    conda activate deep_learning_env

    # Install essential deep learning packages
    echo "Installing essential deep learning packages..."
    conda install -n deep_learning_env -c conda-forge pytorch torchvision scikit-learn pandas matplotlib jupyterlab opencv-python numpy
    echo "Deep learning environment setup completed."
}

# Function to install Git
install_git() {
    if [ -x "$(command -v git)" ]; then
        echo "Git is already installed."
    else
        # Check if the system uses apt package manager (Debian/Ubuntu)
        if [ -x "$(command -v apt)" ]; then
            echo "Installing Git using apt..."
            sudo apt update
            sudo apt install git -y
        # Check if the system uses yum package manager (Red Hat/Fedora)
        elif [ -x "$(command -v yum)" ]; then
            echo "Installing Git using yum..."
            sudo yum install git -y
        # Check if the system uses dnf package manager (Fedora)
        elif [ -x "$(command -v dnf)" ]; then
            echo "Installing Git using dnf..."
            sudo dnf install git -y
        else
            echo "Unable to determine the package manager. Please install Git manually."
            exit 1
        fi

        # Verify the installation
        if [ -x "$(command -v git)" ]; then
            echo "Git installation completed."
        else
            echo "Git installation failed. Please install Git manually."
            exit 1
        fi
    fi
}


# Main script
install_git
install_vscode
install_spotify
install_brave
install_docker
install_vlc
set_wallpaper
set_dock_to_bottom
enable_airpods
install_deep_learning_env
