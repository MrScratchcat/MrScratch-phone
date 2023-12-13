# Phone setup


#install emulator
```bash
sudo apt install curl ca-certificates -y && curl https://repo.waydro.id | sudo bash && sudo apt install waydroid -y
```
#Open waydroid and change android type to GAPPS

#after installation run:
```bash
sudo waydroid shell
```
```bash
ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";"
```
#this command will output an number copy the number and past it at this website: https://www.google.com/android/uncertified
