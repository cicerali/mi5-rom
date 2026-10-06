# PixelGemini OS - Tasks & Project Roadmap

This document outlines the phased development roadmap, completed milestones, and upcoming tasks for **PixelGemini OS (Android 11)** built for the **Xiaomi Mi 5 (gemini)**.

---

## 🎯 Project Vision
Transition the initial LineageOS-based foundation into:
1. **A Pure Google Pixel Experience:** Pixel look, feel, animations, fonts, launcher, and integration.
2. **Independence from LineageOS & Untracked 3rd-Party Dependencies:** Self-hosting and freezing critical repositories (device tree, kernel, vendor blobs) to prevent upstream breaking changes and purge telemetry.
3. **Curated, Ad-Free, Privacy-Focused Pre-installed Apps:** Modern, daily-driver ready apps replacing legacy AOSP utilities.

---

## 📋 Epic 1: Pure Pixel Experience
**Goal:** Transform the Xiaomi Mi 5 into an authentic Google Pixel experience from boot to UI.

- [x] **Task 1.1: Google Pixel Bootanimation (1080p for Mi 5)**
  - Integrated official Google Pixel boot animation (white background with rotating colored 'G' logo) optimized for 1080x1920 display.
  - Installed via `vendor/pixel/bootanimation/bootanimation.zip` into `/system/media/bootanimation.zip`.
- [x] **Task 1.2: Google Sans (Product Sans) System Font Family**
  - Integrated full Google Sans font family (Regular, Medium, Bold, Italic) under `vendor/pixel/fonts/`.
  - Added `/product/etc/fonts_customization.xml` and Android.mk prebuilts.
- [x] **Task 1.3: Pixel Launcher & Google Feed Integration**
  - Configured QuickStep Launcher with native Google Feed (minus-one page) integration powered by MindTheGapps Velvet provider.
- [x] **Task 1.4: Pixel UI Theme, Accent Colors & Round Icons**
  - Integrated Pixel circular icon pack RRO overlays (`IconPackCircularPixelLauncherOverlay`, `IconPackCircularPixelThemePickerOverlay`).
  - Integrated Google DocumentsUI Pixel overlay.
- [x] **Task 1.5: Official Pixel Sound Package (Pixel Sounds)**
  - Integrated 67 official Google Pixel ringtones, notification sounds, alarm tones, and UI audio under `vendor/pixel/audio/`.
  - Configured default props for Pixel ringtone, notification, and alarm.
- [x] **Task 1.6: Official Integrity (Spoofing Excluded)**
  - Decided against device spoofing to maintain 100% genuine system security, official compliance, and privacy ethics. Device retains clean, genuine Android identification without unauthorized property manipulation.

---

## 🛡️ Epic 2: Purging LineageOS & 3rd-Party Dependencies (Full Independence)
**Goal:** Eliminate external breaking risks, purge Lineage telemetry/settings, and self-host all required trees.

- [x] **Task 2.1: Purge LineageOS Telemetry & Custom Interfaces**
  - Completely removed `Updater` (OTA updater), `LineageSetupWizard`, `Seedvault`, `Etar`, `Profiles`, `Backgrounds`, `ExactCalculator`, `Email`, and `Exchange2` from build configurations.
- [x] **Task 2.2: Mirror Critical Trees to Dedicated GitHub Repositories**
  - Self-hosted device tree (`cicerali/android_device_xiaomi_gemini`), common tree (`cicerali/android_device_xiaomi_msm8996-common`), and kernel tree (`cicerali/android_kernel_xiaomi_msm8996`) under `github.com/cicerali`.
  - Updated `manifests/gemini.xml` to point directly to these dedicated repositories.
- [x] **Task 2.3: Self-Host & Isolate Mi 5 Vendor Blobs**
  - Extracted and isolated 219 MB of verified Xiaomi Mi 5 hardware drivers into `github.com/cicerali/proprietary_vendor_xiaomi_gemini`.
  - Updated `scripts/02_init_and_sync.sh` to clone directly from user repository.
- [ ] **Task 2.4: Freeze MindTheGapps Repository**
  - Maintain a verified mirror of `MindTheGapps rho` (Android 11) to eliminate external upstream risks.
- [ ] **Task 2.5: Standalone Build Configurations (AOSP Standard)**
  - Decouple makefiles from `lineage_gemini` into an independent `pixel_gemini.mk` build target.

---

## 📦 Epic 3: Curated, Ad-Free & Reliable Pre-installed App Suite
**Goal:** Replace outdated AOSP apps with modern, ad-free, open-source or official Google solutions.

- [ ] **Task 3.1: Communication Suite (Google Phone, Contacts, Messages)**
  - Replace AOSP Dialer with official **Google Phone** (Spam protection and caller ID).
  - Replace AOSP Contacts with **Google Contacts**.
  - Replace AOSP Messaging with modern RCS-supported **Google Messages**.
- [ ] **Task 3.2: Everyday Core Tools (Clock, Calculator, Keyboard)**
  - Replace AOSP Clock and Calculator with official **Google Clock** and **Google Calculator**.
  - Integrate official **Gboard (Google Keyboard)** with multilingual and glide typing support.
- [x] **Task 3.3: Modern & Ad-Free Weather Application**
  - Integrated official open-source, ad-free, Material You **Breezy Weather** (`v6.2.2`) with Open-Meteo & DWD weather engines into `/product/app/BreezyWeather/`.
- [x] **Task 3.4: Modern File Manager**
  - Integrated clean, lightweight, ad-free **Material Files** (`v1.7.5`) into `/product/app/MaterialFiles/`.
- [ ] **Task 3.5: Priv-App Permissions & Whitelist Configuration**
  - Configure `/etc/permissions/privapp-permissions-pixelgemini.xml` and default runtime permissions to ensure all pre-installed apps boot with zero crashes.
- [ ] **Task 3.6: Essential Authentic Pixel App Suite (Zero Duplicates)**
  - Integrate **Google Calculator** (`com.google.android.calculator`) for clean Material You calculations.
  - Integrate **Google Recorder** (`com.google.android.apps.recorder`) with live audio waveforms.
  - Integrate **Cromite** (Chromium engine with built-in AdBlock & native PDF viewing capabilities).
  - Integrate **Gramophone** (open-source Jetpack Compose Material You offline music player).
  - Integrate **Google Calendar** (`com.google.android.calendar`) for seamless Google account schedule sync.
  - Integrate **Google Photos** (`com.google.android.apps.photos`) as the sole official Pixel gallery, purging legacy AOSP `Gallery2`.
  - Integrate **Gboard** (`com.google.android.inputmethod.latin`) as the default smart keyboard with multilingual glide typing, replacing legacy `LatinIME`.

---

## 📊 Progress & Milestones Tracker

| ID | Task Description | Epic | Status |
| :--- | :--- | :--- | :--- |
| **0.1** | WSL2 300GB VHDX Disk and Environment Setup | Infrastructure | ✅ Completed |
| **0.2** | Base Android 11 (Lineage 18.1) + GApps First Build | Infrastructure | ✅ Completed (`858 MB zip`) |
| **0.3** | GitHub Repository Creation and Documentation | Infrastructure | ✅ Completed |
| **1.1** | Google Pixel Bootanimation (1080p Mi 5) | Epic 1 | ✅ Integrated (`vendor/pixel`) |
| **1.2** | Google Sans (Product Sans) Font Package | Epic 1 | ✅ Integrated (`vendor/pixel`) |
| **1.3** | Pixel Launcher + Google Feed Integration | Epic 1 | ✅ Configured |
| **1.4** | Pixel UI Theme, Round Icons & Pixel Blue Accent | Epic 1 | ✅ Integrated (RRO Overlays) |
| **1.5** | Official Pixel Sound Pack (Ringtones, Alarms) | Epic 1 | ✅ Integrated (67 tracks) |
| **1.6** | Official Integrity (No Spoofing) | Epic 1 | ✅ Confirmed (Genuine Identity) |
| **2.1** | Purge LineageParts, LineageUpdater & Telemetry | Epic 2 | ✅ Completed & Debloated |
| **2.2** | Mirror Device, Common & Kernel Trees to GitHub | Epic 2 | ✅ Completed (100% Self-Hosted) |
| **2.3** | Self-Host Mi 5 Proprietary Vendor Blobs | Epic 2 | ✅ Completed (`cicerali/proprietary...`) |
| **2.6** | End-to-End Clean Build Verification (`build_all.sh --clean`) | Epic 2 | ✅ Completed (`908 MB zip verified`) |
| **3.1** | Google Communication Suite (Phone, Contacts, Messages) | Epic 3 | ⏳ Queued |
| **3.2** | Google Core Tools (Clock, Calculator, Gboard) | Epic 3 | ⏳ Queued |
| **3.3** | Ad-Free Weather App (Breezy Weather) | Epic 3 | ✅ Integrated & Verified (`v6.2.2`) |
| **3.4** | Modern File Manager Integration | Epic 3 | ✅ Integrated & Verified (`v1.7.5`) |
| **3.6** | Essential Authentic Pixel Suite (Calc, Recorder, Cromite, Music, Calendar, Photos, Gboard) | Epic 3 | ⏳ Next Up (Ready to implement) |
