
val lib by configurations.creating {
    isTransitive = false
    isCanBeResolved = true
    isCanBeConsumed = true
}
val lib_ext by configurations.creating {
    isTransitive = false
    isCanBeResolved = true
    isCanBeConsumed = true
}

//plugins/lib/ext
dependencies {
    lib_ext("com.datadoghq:jmeter-datadog-backend-listener:0.3.0")
    lib_ext("kg.apc:jmeter-plugins-casutg:2.10")
    lib_ext("com.blazemeter:jmeter-plugins-random-csv-data-set:0.8")
    lib_ext("com.microsoft.sqlserver:mssql-jdbc:10.2.1.jre17")
    lib_ext("com.oracle.database.jdbc:ojdbc10:19.14.0.0")
    lib_ext("kg.apc:jmeter-plugins-functions:2.1")
    // remove log4j shell
    lib_ext("org.apache.logging.log4j:log4j-slf4j-impl:2.17.2")
    lib_ext("org.apache.logging.log4j:log4j-api:2.17.2")
    lib_ext("org.apache.logging.log4j:log4j-core:2.17.2")

    lib_ext("org.mozilla:rhino-engine:1.7.13")

//plugins/lib
    lib("kg.apc:cmdrunner:2.3")
    lib("kg.apc:jmeter-plugins-cmn-jmeter:0.7")
    lib("net.sf.json-lib:json-lib:2.4:jdk15")
    // remove log4j shell
    lib("org.apache.logging.log4j:log4j-slf4j-impl:2.17.2")
    lib("org.apache.logging.log4j:log4j-api:2.17.2")
    lib("org.apache.logging.log4j:log4j-core:2.17.2")

// apache log4j
    lib("org.apache.logging.log4j:log4j-1.2-api:2.17.2")
    lib("org.apache.logging.log4j:log4j-api:2.17.2")
    lib("org.apache.logging.log4j:log4j-core:2.17.2")
    lib("org.apache.logging.log4j:log4j-slf4j-impl:2.17.2")
}

repositories {
    mavenCentral()
}

tasks {
    register<Copy>("copyPluginsLibExt") {
        from(lib) {
            into("lib")
        }
        from(lib_ext) {
            into("lib/ext")
        }
        into(layout.buildDirectory.dir("jmeter"))
    }
}