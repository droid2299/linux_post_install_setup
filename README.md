# Bash Script for Ubuntu Setup and Deep Learning Environment

This bash script is designed to automate the installation of various useful software packages and configure specific settings for an Ubuntu system. It installs Visual Studio Code, Spotify, Brave Browser, Docker, VLC, and sets a custom wallpaper using the GNOME desktop environment. Additionally, the script enables AirPods to work on Ubuntu and creates a basic deep learning environment using Anaconda with essential packages like PyTorch, TensorFlow, scikit-learn, pandas, and more.

## Instructions:

1. Clone the Repo, e.g., `git clone https://github.com/droid2299/linux_post_install_setup.git`.
2. Make the script executable: `chmod +x linux_post_install_Setup.sh`.
3. Run the script with superuser privileges: `sudo ./linux_post_install_Setup.sh`.

## List of Actions Performed:

- Installs Git, Visual Studio Code, Spotify, Brave Browser, Docker, and VLC.
- Downloads a custom wallpaper and sets it as the desktop background.
- Sets the Ubuntu dock to the bottom and adjusts its length based on the number of icons.
- Enables AirPods to work on Ubuntu by configuring the necessary audio settings.
- Installs Anaconda and creates a new conda environment named `deep_learning_env`.
- Installs essential deep learning packages within the `deep_learning_env`.

## Notes:

- For the wallpaper, replace `"YOUR_GITHUB_RAW_IMAGE_LINK"` with the direct link to your desired wallpaper image on GitHub.
- The script assumes a 64-bit Ubuntu system. If using a different OS or architecture, adjust the package names and installation commands accordingly.

> **Disclaimer:** Please review the script carefully and ensure it aligns with your system's requirements before executing it.
