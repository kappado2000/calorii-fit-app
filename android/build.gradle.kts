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

// camera_android_camerax's own compileDebugJavaWithJavac fails without this
// — camera-core 1.5.3's SurfaceRequest.class carries a type-use annotation
// referencing androidx.concurrent.futures.CallbackToFutureAdapter, and javac
// needs that class file on *this specific subproject's* compile classpath to
// process it, which the plugin's own build.gradle doesn't provide. Adding it
// to android/app/build.gradle.kts doesn't help, since each Gradle subproject
// compiles against its own dependency set, not the app's.
subprojects {
    if (name == "camera_android_camerax") {
        afterEvaluate {
            dependencies.add("implementation", "androidx.concurrent:concurrent-futures:1.2.0")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
