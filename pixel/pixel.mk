#
# Copyright (C) 2026 PixelGemini OS Project
# Pure Pixel Experience definitions for Xiaomi Mi 5 (gemini)
#

# 1. Official Google Pixel Bootanimation (1080x1920)
TARGET_BOOTANIMATION := vendor/pixel/bootanimation/bootanimation.zip

# 2. Google Sans (Product Sans) Font Family
PRODUCT_COPY_FILES += \
    vendor/pixel/fonts/GoogleSans-Bold.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Bold.ttf \
    vendor/pixel/fonts/GoogleSans-BoldItalic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-BoldItalic.ttf \
    vendor/pixel/fonts/GoogleSans-Italic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Italic.ttf \
    vendor/pixel/fonts/GoogleSans-Medium.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Medium.ttf \
    vendor/pixel/fonts/GoogleSans-MediumItalic.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-MediumItalic.ttf \
    vendor/pixel/fonts/GoogleSans-Regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/GoogleSans-Regular.ttf \
    vendor/pixel/fonts/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# 3. Official Pixel Sounds (Ringtones, Notifications, Alarms, UI)
$(call inherit-product, vendor/pixel/audio/audio.mk)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg \
    ro.config.notification_sound=Popcorn.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

# 4. Pixel RRO Overlays (Circular Icons & DocumentsUI)
PRODUCT_PACKAGES += \
    IconPackCircularPixelLauncherOverlay \
    IconPackCircularPixelThemePickerOverlay \
    PixelDocumentsUIGoogleOverlay

# 5. Curated Ad-Free Pre-installed Applications
PRODUCT_PACKAGES += \
    BreezyWeather \
    MaterialFiles

