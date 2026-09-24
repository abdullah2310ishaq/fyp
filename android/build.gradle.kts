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

fun Project.forceCompileSdk36() {
    val android = extensions.findByName("android") ?: return
    android.javaClass.methods
        .firstOrNull { it.name == "setCompileSdk" && it.parameterCount == 1 }
        ?.invoke(android, 36)
    android.javaClass.methods
        .firstOrNull {
            it.name == "compileSdkVersion" &&
                it.parameterCount == 1 &&
                it.parameterTypes[0] == Int::class.javaPrimitiveType
        }
        ?.invoke(android, 36)
}

subprojects {
    // evaluationDependsOn(":app") can evaluate a project before this block
    // registers afterEvaluate; set compileSdk after the plugin's own android {} .
    val bump = Action<Project> { forceCompileSdk36() }
    if (state.executed) {
        bump.execute(this)
    } else {
        afterEvaluate(bump)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
