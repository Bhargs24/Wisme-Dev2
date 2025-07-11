// Root-level build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    id("com.android.application") version "8.7.0" apply false
    id("kotlin-android") apply false
    // Google Services plugin for Firebase
    id("com.google.gms.google-services") version "4.4.0" apply false
    // Flutter plugin must come last
    id("dev.flutter.flutter-gradle-plugin") apply false
}
