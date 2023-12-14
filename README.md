![alt text](https://yt3.googleusercontent.com/9044izhFlUNENR6-RFZ3UpNRw4G20t9ctP-CwMeTYK4frYwjjU6XdNlZFVHoxmIsYu3G0O_Qvqg=s900-c-k-c0x00ffffff-no-rj)


#Phone setup

#Install emulator
```bash
sudo apt install curl ca-certificates -y && curl https://repo.waydro.id | sudo bash && sudo apt install waydroid -y
```
#Open waydroid and change android type to GAPPS

#After installation run:
```bash
sudo waydroid shell
```
#Run this in this shell:
```bash
ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";"
```
#This command will output an number copy the number and past it at this website: https://www.google.com/android/uncertified

#Give the Google services some minutes to reflect the change, then restart waydroid



#Install waydroid for kali:
```bash
sudo apt update && sudo apt upgrade -y && export distro=bullseye && sudo curl https://repo.waydro.id/waydroid.gpg --output /usr/share/keyrings/waydroid.gpg
echo "deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ ${distro} main" | \
  sudo tee /etc/apt/sources.list.d/waydroid.list && sudo apt update
sudo apt install -y \
  build-essential cdbs devscripts equivs fakeroot \
  git kde-plasma-desktop git-buildpackage git-lfs \
  libgbinder-dev && sudo wget https://raw.githubusercontent.com/MrCyjaneK/waydroid-build/main/build_changelog \
  -O /usr/bin/build_changelog
sudo chmod +x ${_} && mkdir ~/build-packages
cd ${_}
git clone https://github.com/waydroid/gbinder-python
cd gbinder-python
build_changelog
sudo mk-build-deps -ir -t "apt -o Debug::pkgProblemResolver=yes -y --no-install-recommends"
sudo debuild -b -uc -us
sudo apt install -f -y ../*.deb && sudo apt install waydroid -y
```
#Reboot now and then start your os with KDE
#Then execute the other instructions 
