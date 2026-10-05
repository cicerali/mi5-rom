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

- [ ] **Task 1.1: Google Pixel Bootanimation (1080p for Mi 5)**
  - Integrate official Google Pixel boot animation (white background with rotating colored 'G' logo) optimized for 1080x1920 display.
  - Install target: `/system/media/bootanimation.zip`.
- [ ] **Task 1.2: Google Sans (Product Sans) System Font Family**
  - Replace default Roboto fonts across the entire system (lock screen, status bar, quick settings, apps) with Google Sans (Regular, Medium, Bold, Italic) via `/etc/fonts.xml`.
- [ ] **Task 1.3: Pixel Launcher & Google Feed Integration**
  - Integrate Pixel Launcher with native Google Feed (Discover / minus-one screen) and "At a Glance" weather/calendar widget.
- [ ] **Task 1.4: Pixel UI Theme, Accent Colors & Round Icons**
  - Set default system accent to Google Pixel Blue (`#4285F4`).
  - Configure default round adaptive icon shapes and Pixel Settings visual styling.
- [ ] **Task 1.5: Official Pixel Sound Package (Pixel Sounds)**
  - Integrate official Google Pixel ringtones, notification sounds, and alarm tones under `/system/media/audio/`.
- [ ] **Task 1.6: Google Photos Unlimited Original Storage Spoofing**
  - Configure device profile spoofing for Google Photos to enable unlimited original quality cloud backup.

---

## 🛡️ Epic 2: Purging LineageOS & 3rd-Party Dependencies (Full Independence)
**Goal:** Eliminate external breaking risks, purge Lineage telemetry/settings, and self-host all required trees.

- [ ] **Task 2.1: Purge LineageOS Telemetry & Custom Interfaces**
  - Completely remove `LineageParts`, `LineageUpdater` (OTA updater), `Trust` security interface, and telemetry packages from build configuration and Settings.
- [ ] **Task 2.2: Mirror Critical Trees to Dedicated GitHub Repositories**
  - Fork and mirror device tree (`device/xiaomi/gemini`), common tree (`device/xiaomi/msm8996-common`), and kernel tree (`kernel/xiaomi/msm8996`) under user's GitHub organization (`github.com/cicerali/...`).
  - Update `manifests/gemini.xml` to point directly to these dedicated repositories.
- [ ] **Task 2.3: Self-Host & Isolate Mi 5 Vendor Blobs**
  - Extract only `gemini` and `msm8996-common` blobs from TheMuppets and maintain a standalone `proprietary_vendor_xiaomi_gemini` repository.
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
- [ ] **Task 3.3: Modern & Ad-Free Weather Application**
  - Pre-install open-source, ad-free, Material You **Breezy Weather** (or official Pixel Weather provider).
- [ ] **Task 3.4: Modern File Manager**
  - Pre-install clean, tag-supported **Google Files** or open-source **Material Files**.
- [ ] **Task 3.5: Priv-App Permissions & Whitelist Configuration**
  - Configure `/etc/permissions/privapp-permissions-pixelgemini.xml` and default runtime permissions to ensure all pre-installed apps boot with zero crashes.

---

## 📊 Progress & Milestones Tracker

| ID | Task Description | Epic | Status |
| :--- | :--- | :--- | :--- |
| **0.1** | WSL2 300GB VHDX Disk and Environment Setup | Infrastructure | ✅ Completed |
| **0.2** | Base Android 11 (Lineage 18.1) + GApps First Build | Infrastructure | ✅ Completed (`858 MB zip`) |
| **0.3** | GitHub Repository Creation and Documentation | Infrastructure | ✅ Completed |
| **1.1** | Google Pixel Bootanimation (1080p Mi 5) | Epic 1 | ⏳ Next Up |
| **1.2** | Google Sans (Product Sans) Font Package | Epic 1 | ⏳ Queued |
| **1.3** | Pixel Launcher + Google Feed Integration | Epic 1 | ⏳ Queued |
| **1.4** | Pixel UI Theme, Round Icons & Pixel Blue Accent | Epic 1 | ⏳ Queued |
| **1.5** | Official Pixel Sound Pack (Ringtones, Alarms) | Epic 1 | ⏳ Queued |
| **1.6** | Google Photos Unlimited Storage Spoofing | Epic 1 | ⏳ Queued |
| **2.1** | Purge LineageParts, LineageUpdater & Telemetry | Epic 2 | ⏳ Queued |
| **2.2** | Mirror Device, Common & Kernel Trees to GitHub | Epic 2 | ⏳ Queued |
| **2.3** | Self-Host Mi 5 Proprietary Vendor Blobs | Epic 2 | ⏳ Queued |
| **3.1** | Google Communication Suite (Phone, Contacts, Messages) | Epic 3 | ⏳ Queued |
| **3.2** | Google Core Tools (Clock, Calculator, Gboard) | Epic 3 | ⏳ Queued |
| **3.3** | Ad-Free Weather App (Breezy Weather) | Epic 3 | ⏳ Queued |
| **3.4** | Modern File Manager Integration | Epic 3 | ⏳ Queued |
