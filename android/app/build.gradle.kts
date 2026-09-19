import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ─── Load signing credentials from key.properties (DO NOT commit this file) ───
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // Internal namespace (keep as-is for Kotlin/R class generation)
    namespace = "com.krishnajewellers.krishnajewellers"

    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // ──────────────────────────────────────────────────────────
        //  PLAY STORE APPLICATION ID — clean package name, no underscores
        // ──────────────────────────────────────────────────────────
        applicationId = "com.krishnajewellers.krishnajewellers"

        // ──────────────────────────────────────────────────────────
        //  SDK TARGETS
        //  minSdk 23 = Android 6.0 (covers 98%+ of active devices)
        //  targetSdk 35 = Android 15 (latest Play Store requirement)
        // ──────────────────────────────────────────────────────────
        minSdk = flutter.minSdkVersion
        targetSdk = 36

        // ──────────────────────────────────────────────────────────
        //  VERSIONING
        //  versionCode: increase by 1 on every Play Store upload
        //  versionName: human-readable "Major.Minor.Patch"
        // ──────────────────────────────────────────────────────────
        versionCode = 9
        versionName = "1.5.4"

        // Multi-language support
        resourceConfigurations += listOf("en", "hi")
    }

    // ─── Release Signing Config ──────────────────────────────────
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias     = keystoreProperties["keyAlias"]     as String
                keyPassword  = keystoreProperties["keyPassword"]  as String
                storeFile    = file(keystoreProperties["storeFile"] as String)
                storePassword= keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        // ─── Release (Play Store) ────────────────────────────────
        release {
            isMinifyEnabled   = true   // R8 code shrinking
            isShrinkResources = true   // Remove unused resources
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Use release signing if key.properties exists, else debug
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }

        // ─── Debug (development) ─────────────────────────────────
        debug {
            applicationIdSuffix = ".debug"
            versionNameSuffix   = "-debug"
            isDebuggable        = true
        }
    }

    // ─── Bundle / AAB Output ────────────────────────────────────
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}
