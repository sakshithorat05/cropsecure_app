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
    project.plugins.withId("com.android.library") {
        if (project.name == "pytorch_lite") {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val namespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                    namespaceMethod.invoke(android, "com.zezo357.pytorch_lite")
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
        if (project.name == "camera_android_camerax") {
            project.dependencies.add("compileOnly", "androidx.concurrent:concurrent-futures:1.2.0")
            project.dependencies.add("implementation", "androidx.concurrent:concurrent-futures:1.2.0")
        }
    }
}

subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        val targetCompatibility = project.tasks.withType<JavaCompile>().firstOrNull()?.targetCompatibility
            ?: try {
                val android = project.extensions.findByName("android")
                val compileOptions = android?.javaClass?.getMethod("getCompileOptions")?.invoke(android)
                val targetComp = compileOptions?.javaClass?.getMethod("getTargetCompatibility")?.invoke(compileOptions)
                targetComp?.toString()
            } catch (e: Exception) {
                null
            }

        val target = when (targetCompatibility) {
            "1.8", "8" -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
            "11" -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11
            "17" -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
            "21" -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21
            else -> org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
        }
        compilerOptions {
            jvmTarget.set(target)
        }
    }
}
