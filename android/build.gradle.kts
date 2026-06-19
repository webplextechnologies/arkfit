buildscript {

    repositories {
      // Make sure that you have the following two repositories
      google()  // Google's Maven repository
      mavenCentral()  // Maven Central repository
    }

    dependencies {
      classpath("com.google.gms:google-services:4.4.4")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    configurations.all {
        resolutionStrategy {
            // Android 15 requires at least 1.13.0+ to avoid the Stylus crash
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
            
            // Keep your activity versions as they are or update to 1.9.3
            force("androidx.activity:activity:1.9.3")
            force("androidx.activity:activity-ktx:1.9.3")
        }
    }
}
subprojects {
    configurations.all {
        resolutionStrategy {
            force("androidx.browser:browser:1.8.0")
        }
    }
}
