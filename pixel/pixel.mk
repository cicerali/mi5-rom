#
# Copyright (C) 2026 PixelGemini OS Project
# Pure Pixel Experience definitions for Xiaomi Mi 5 (gemini)
#

# 1. Official Google Pixel Bootanimation (1080x1920)
PRODUCT_COPY_FILES += \
    vendor/pixel/bootanimation/bootanimation.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

# 2. Google Sans (Product Sans) Font Family
PRODUCT_PACKAGES += \
    GoogleSans-Bold \
    GoogleSans-BoldItalic \
    GoogleSans-Italic \
    GoogleSans-Medium \
    GoogleSans-MediumItalic \
    GoogleSans-Regular

PRODUCT_COPY_FILES += \
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
