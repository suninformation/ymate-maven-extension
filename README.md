## YMPv2 Maven扩展工具

目前YMP扩展工具支持以下几种项目模板：

- YMP Quickstart Archetype：
> 标准Java工程，已集成YMP-Core等依赖；

- YMP Webapp Archetype：
> JavaWeb工程，已集成YMP-WebMVC框架相关依赖和完整的参数配置。

- YMP Module Archetype：
> YMP模块工程，提供Demo示例及JUint测试代码。

- YMP Serv Archetype：
> YMP服务工程，分别提供TCP、UDP客户端和服务端示例程序及相关配置。

### 使用说明

#### 一、准备工作

> 注：如果您尚未编译、安装YMPv2框架包，请前往[YMP官网](http://www.ymate.net/)下载。

手动编译并安装`ymate-maven-extension`扩展工具到本地Maven仓库:

步骤1：下载扩展工具源码

    执行命令：git clone https://git.oschina.net/suninformation/ymate-maven-extension.git

步骤2：编译并安装到本地Maven仓库

    执行命令: cd ymate-maven-extension
             mvn clean install

#### 二、搭建工程

步骤1：开启本地archetype向导

    执行命令：mvn archetype:generate -DarchetypeCatalog=local

屏幕输出：

    Choose archetype:
    1: local -> net.ymate.maven.archetypes:ymate-archetype-module (module)
    2: local -> net.ymate.maven.archetypes:ymate-archetype-quickstart (quickstart)
    3: local -> net.ymate.maven.archetypes:ymate-archetype-serv (serv)
    4: local -> net.ymate.maven.archetypes:ymate-archetype-webapp (webapp)
    Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): :

> 注：若执行命令没有显示上述内容，请执行`mvn archetype:crawl`命令后再试！

步骤2：根据实际需求选择项目模板类型，这里我选择：4

屏幕输出，接下来要按屏幕提示进行设置：

    Define value for property 'groupId': : net.ymate.platform.examples
    Define value for property 'artifactId': : ymp-examples-webapp
    Define value for property 'version':  1.0-SNAPSHOT: :
    Define value for property 'package':  net.ymate.platform.examples: :
    Confirm properties configuration:
    groupId: net.ymate.platform.examples
    artifactId: ymp-examples-webapp
    version: 1.0-SNAPSHOT
    package: net.ymate.platform.examples
     Y: :

回车键确认后，开始生成工程结构：

    [INFO] ----------------------------------------------------------------------------
    [INFO] Using following parameters for creating project from Archetype: ymate-archetype-webapp:1.0-SNAPSHOT
    [INFO] ----------------------------------------------------------------------------
    [INFO] Parameter: groupId, Value: net.ymate.platform.examples
    [INFO] Parameter: artifactId, Value: ymp-examples-webapp
    [INFO] Parameter: version, Value: 1.0-SNAPSHOT
    [INFO] Parameter: package, Value: net.ymate.platform.examples
    [INFO] Parameter: packageInPathFormat, Value: net/ymate/platform/examples
    [INFO] Parameter: package, Value: net.ymate.platform.examples
    [INFO] Parameter: version, Value: 1.0-SNAPSHOT
    [INFO] Parameter: groupId, Value: net.ymate.platform.examples
    [INFO] Parameter: artifactId, Value: ymp-examples-webapp
    [INFO] project created from Archetype in dir: /Users/suninformation/Temp/ymp-examples-webapp
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 1:08.723s
    [INFO] Finished at: Thu Mar 17 11:00:54 CST 2016
    [INFO] Final Memory: 13M/155M
    [INFO] ------------------------------------------------------------------------

至此，基于扩展工具快速搭建YMP工程已完成！

#### 三、编译并运行

首先，进入新创建的工程目录中，执行如下命令：

	cd ymp-examples-webapp

然后，通过Maven进行代码编译并打包，执行如下命令：

	mvn clean compile package

屏幕输出：

	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	[INFO] Scanning for projects...
	[INFO]
	[INFO] ------------------------------------------------------------------------
	[INFO] Building ymp-examples-webapp 1.0-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] ......（此处省略10000字）
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 2.582s
	[INFO] Finished at: Thu Mar 17 11:43:19 CST 2016
	[INFO] Final Memory: 17M/212M
	[INFO] ------------------------------------------------------------------------

最后，通过Maven启动Tomcat服务并运行war包，执行如下命令：

	mvn tomcat:run-war

屏幕输出：

	Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
	[INFO] Scanning for projects...
	[INFO]
	[INFO] ------------------------------------------------------------------------
	[INFO] Building ymp-examples-webapp 1.0-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO]
	[INFO] ......（此处省略10000字）
	[INFO]
	[INFO] <<< tomcat-maven-plugin:1.1:run-war (default-cli) @ ymp-examples-webapp <<<
	[INFO]
	[INFO] --- tomcat-maven-plugin:1.1:run-war (default-cli) @ ymp-examples-webapp ---
	[INFO] Running war on http://localhost:8080/ymp-examples-webapp
	[INFO] Creating Tomcat server configuration at /Users/suninformation/Temp/ymp-examples-webapp/target/tomcat
	三月 17, 2016 11:48:31 上午 org.apache.catalina.startup.Embedded start
	信息: Starting tomcat server
	三月 17, 2016 11:48:32 上午 org.apache.catalina.core.StandardEngine start
	信息: Starting Servlet Engine: Apache Tomcat/6.0.29
	[INFO] YMP -
	__   ____  __ ____          ____
	\ \ / /  \/  |  _ \  __   _|___ \
	 \ V /| |\/| | |_) | \ \ / / __) |
	  | | | |  | |  __/   \ V / / __/
	  |_| |_|  |_|_|       \_/ |_____|  Website: http://www.ymate.net/
	[INFO] YMP - Initializing ymate-platform-core-2.0.0-GA build-20160315-0206 - debug:true
	[INFO] Validations - Initializing ymate-platform-validation-2.0.0-GA build-20160315-0206
	[INFO] WebMVC - Initializing ymate-platform-webmvc-2.0.0-GA build-20160315-0206
	[INFO] Caches - Initializing ymate-platform-cache-2.0.0-GA build-20160315-0206
	[INFO] Logs - Initializing ymate-platform-log-2.0.0-GA build-20160315-0206
	[INFO] Cfgs - Initializing ymate-platform-configuration-2.0.0-GA build-20160315-0206
	[INFO] ......（此处省略10000字）
	[INFO] YMP - Initialization completed, Total time: 839ms
	三月 17, 2016 11:48:33 上午 org.apache.coyote.http11.Http11Protocol init
	信息: Initializing Coyote HTTP/1.1 on http-8080
	三月 17, 2016 11:48:33 上午 org.apache.coyote.http11.Http11Protocol start
	信息: Starting Coyote HTTP/1.1 on http-8080

看到上面输出信息，说明Tomcat服务已启动，并已成功运行war包。

请打开浏览器访问：[http://localhost:8080/ymp-examples-webapp/](http://localhost:8080/ymp-examples-webapp/)

浏览器输出内容：

	Hello YMP world!


**Congratulations!**，恭喜你成功使用Maven完成了对YMP项目的创建、编译、运行等一系列操作，是不是很简单，大家可以动手尝试一下！


#### One More Thing

YMP不仅提供便捷的Web及其它Java项目的快速开发体验，也将不断提供更多丰富的项目实践经验。

感兴趣的小伙伴儿们可以加入 官方QQ群480374360，一起交流学习，帮助YMP成长！

了解更多有关YMP框架的内容，请访问官网：http://www.ymate.net/
