PRODUCT_BRAND ?= Havoc-OS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

EXCLUDE_SYSTEMUI_TESTS := true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.opa.eligible_device=true \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.build.selinux=1 \
    ro.carrier=unknown

PRODUCT_PROPERTY_OVERRIDES := \
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg \
    ro.config.notification_sound=Ping.ogg \
    ro.config.alarm_alert=Spokes.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# Whitelist packages for location providers not in system
PRODUCT_PROPERTY_OVERRIDES += \
    ro.services.whitelist.packagelist=com.google.android.gms

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/havoc/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/havoc/prebuilt/common/bin/50-havoc.sh:system/addon.d/50-havoc.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/havoc/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/havoc/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/havoc/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/havoc/config/permissions/havoc-power-whitelist.xml:system/etc/sysconfig/havoc-power-whitelist.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/mkshrc:system/etc/mkshrc

# Copy all Havoc-specific init rc files
$(foreach f,$(wildcard vendor/havoc/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/sensitive_pn.xml:system/etc/sensitive_pn.xml

# World APN list
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Fix Google dialer
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# LatinIME gesture typing
ifeq ($(SUDA_CPU_ABI),arm64-v8a)
PRODUCT_PACKAGES += \
    GooglePinYin

 PRODUCT_COPY_FILES += $(shell test -d vendor/havoc/prebuilt/app/GooglePinYin && \
    find vendor/havoc/prebuilt/app/GooglePinYin -name '*.so' \
    -printf '%p:system/app/GooglePinYin/lib/arm64/%f ')
else
PRODUCT_PACKAGES += \
    LatinIME

PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/havoc/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Havoc Packages
PRODUCT_PACKAGES += \
    Calculator \
    DeskClock \
    LiveWallpapers \
    LiveWallpapersPicker\
    messaging \
    PixelLauncher \
    SoundPickerPrebuilt \
    Stk \
    Terminal \
    WallpaperPickerGooglePrebuilt \
    WeatherProvider

# Required packages
PRODUCT_PACKAGES += \
    PhoneLocationProvider \
    ForceStop \
    Calendar \
    ViaBrowser

# Fonts
PRODUCT_PACKAGES += \
    Havoc-Fonts

# Phonelocation!
PRODUCT_COPY_FILES +=  \
    vendor/havoc/prebuilt/common/media/location/suda-phonelocation.dat:system/media/location/suda-phonelocation.dat

# WeatherProvider
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/permissions/com.android.providers.weather.xml:system/etc/permissions/com.android.providers.weather.xml \
    vendor/havoc/prebuilt/common/etc/default-permissions/com.android.providers.weather.xml:system/etc/default-permissions/com.android.providers.weather.xml

# Substratum Key
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/priv-app/SubstratumKey.apk:system/priv-app/SubstratumKey/SubstratumKey.apk
	
# Themes
PRODUCT_PACKAGES += \
    SettingsDarkTheme \
    SystemDarkTheme \
    SystemUIDarkTheme \
    SettingsBlackTheme \
    SystemBlackTheme \
    SystemUIBlackTheme

# Notification themes
PRODUCT_PACKAGES += \
    NotificationBlackTheme \
    NotificationDarkTheme

# Accents
PRODUCT_PACKAGES += \
    Amber \
    Black \
    Blue \
    BlueGrey \
    Brown \
    CandyRed \
    Cyan \
    DeepOrange \
    DeepPurple \
    ExtendedGreen \
    Green \
    Grey \
    Indigo \
    JadeGreen \
    LightBlue \
    LightGreen \
    Lime \
    Orange \
    PaleBlue \
    PaleRed \
    Pink \
    Purple \
    Red \
    Teal \
    Yellow \
    White \
    UserOne \
    UserTwo \
    UserThree \
    UserFour \
    UserFive \
    UserSix \
    UserSeven \
    ObfusBleu \
    NotImpPurple \
    Holillusion \
    MoveMint \
    FootprintPurple \
    BubblegumPink \
    FrenchBleu \
    Stock \
    ManiaAmber \
    SeasideMint \
    DreamyPurple \
    SpookedPurple \
    HeirloomBleu \
    TruFilPink \
    WarmthOrange \
    ColdBleu \
    DiffDayGreen \
    DuskPurple \
    BurningRed \
    HazedPink \
    ColdYellow \
    NewHouseOrange \
    IllusionsPurple

# QS tile styles
PRODUCT_PACKAGES += \
    QStileDefault \
    QStileCircleTrim \
    QStileCircleDualTone \
    QStileCircleGradient \
    QStileCookie \
    QStileDottedCircle \
    QStileDualToneCircle \
    QStileInk \
    QStileInkdrop \
    QStileMountain \
    QStileNinja \
    QStileOreo \
    QStileOreoCircleTrim \
    QStileOreoSquircleTrim \
    QStilePokesign \
    QStileSquaremedo \
    QStileSquircle \
    QStileSquircleTrim \
    QStileTeardrop \
    QStileWavey

# QS header styles
PRODUCT_PACKAGES += \
    QSHeaderBlack \
    QSHeaderGrey \
    QSHeaderLightGrey \
    QSHeaderAccent \
    QSHeaderTransparent

# QS accents
PRODUCT_PACKAGES += \
    QSAccentBlack \
    QSAccentWhite

# UI themes
PRODUCT_PACKAGES += \
    AOSPUI \
    PixelUI

# Switch themes
PRODUCT_PACKAGES += \
    MD2Switch \
    OnePlusSwitch \
    StockSwitch

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# Sysconfig
PRODUCT_COPY_FILES += \
    vendor/havoc/prebuilt/common/etc/sysconfig/google-hiddenapi-package-whitelist.xml:system/etc/sysconfig/google-hiddenapi-package-whitelist.xml \
    vendor/havoc/prebuilt/common/etc/sysconfig/pixel.xml:system/etc/sysconfig/pixel.xml

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in Havoc
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    htop \
    lib7z \
    libsepol \
    pigz \
    powertop \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Custom off-mode charger
ifeq ($(WITH_HAVOC_CHARGER),true)
PRODUCT_PACKAGES += \
    havoc_charger_res_images \
    font_log.png \
    libhealthd.havoc
endif

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# GBoard Themes
PRODUCT_COPY_FILES += \
    vendor/havoc/themes/GBoard/MD2.zip:system/etc/gboard/MD2.zip \
    vendor/havoc/themes/GBoard/MD2Black.zip:system/etc/gboard/MD2Black.zip \
    vendor/havoc/themes/GBoard/MD2Dark.zip:system/etc/gboard/MD2Dark.zip

# Set Pixel blue light MD2 theme on Gboard
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.ime.themes_dir=/system/etc/gboard \
    ro.com.google.ime.theme_file=MD2.zip

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Disable rescue party
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.disable_rescue=true

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/havoc/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/havoc/overlay/common

# Bootanimation
include vendor/havoc/config/bootanimation.mk

# Version
include vendor/havoc/config/version.mk
