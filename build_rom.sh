# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/NusantaraProject-ROM/android_manifest.git -b 11 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/Fraschze97/local_manifest --depth=1 -b 30A-NAD11 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# patch
cd external/selinux 
curl -LO https://raw.githubusercontent.com/SamarV-121/android_vendor_extra/lineage-18.1/patches/external/selinux/0001-Revert-libsepol-Make-an-unknown-permission-an-error-.patch
patch -p1 < *.patch
cd ../..

# build rom
. build/envsetup.sh
lunch nad_RMX1821-userdebug
export SKIP_API_CHECKS=true
export SKIP_ABI_CHECKS=true
export TZ=Asia/Jakarta
mka nad
 
# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
