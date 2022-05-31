
val jmeterlibs by configurations.creating {
    isCanBeResolved = true
    isCanBeConsumed = true
    isTransitive = false
}

val plugins_lib_ext by configurations.creating {
    extendsFrom(jmeterlibs)
}
val plugins_lib by configurations.creating {
    extendsFrom(jmeterlibs)
}
val lib_ext by configurations.creating {
    extendsFrom(jmeterlibs)
}
//plugins/lib/ext
dependencies {
    plugins_lib_ext("com.datadoghq:jmeter-datadog-backend-listener:0.3.0")
    plugins_lib_ext("kg.apc:jmeter-plugins-casutg:2.10")
    plugins_lib_ext("com.blazemeter:jmeter-plugins-random-csv-data-set:0.8")
    plugins_lib_ext("com.microsoft.sqlserver:mssql-jdbc:10.2.1.jre17")
    plugins_lib_ext("com.oracle.database.jdbc:ojdbc10:19.14.0.0")

//plugins/lib
    plugins_lib("kg.apc:cmdrunner:2.3")
    plugins_lib("kg.apc:jmeter-plugins-cmn-jmeter:0.7")
    plugins_lib("net.sf.json-lib:json-lib:2.4:jdk15")

//lib/ext
    lib_ext("org.mozilla:rhino-engine:1.7.13")
}

repositories {
    mavenCentral()
}

tasks {
    register<Copy>("copyPluginsLibExt") {
        from(plugins_lib_ext) {
            into("plugins/lib/ext")
        }

        from(plugins_lib) {
            into("plugins/lib")
        }
        from(lib_ext) {
            into("lib/ext")
        }
        into(layout.buildDirectory.dir("jmeter"))
    }
}