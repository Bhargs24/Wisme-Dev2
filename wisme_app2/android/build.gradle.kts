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
    // Flutter plugin must come last
    id("dev.flutter.flutter-gradle-plugin") apply false
}
