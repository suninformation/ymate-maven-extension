### YMP-Maven-Extension（YMP Maven扩展工具）

帮助您快速搭建基于[YMP框架](https://gitee.com/suninformation/ymate-platform-v2)的各种Java工程结构的Maven扩展工具集合，主要包括`项目模板`和`Maven插件命令`两部分。

> YMP框架项目地址：[https://gitee.com/suninformation/ymate-platform-v2](https://gitee.com/suninformation/ymate-platform-v2)

#### 1、项目模板

目前提供以下5种项目模板：

- `ymate-archetype-quickstart (quickstart)`：标准Java工程，已集成YMP依赖；

- `ymate-archetype-webapp (webapp)`：JavaWeb工程，已集成WebMVC框架相关依赖和完整的参数配置；

- `ymate-archetype-module (module)`：YMP模块工程，提供Demo示例及JUint测试代码；

- `ymate-archetype-serv (serv)`：YMP服务工程，分别提供TCP、UDP客户端和服务端示例程序及相关配置；

- `ymate-archetype-microservice (microservice)`：YMP微服务多模块Maven工程；

> 查看使用文档：[通过项目模板自动生成Java工程](https://gitee.com/suninformation/ymate-platform-v2/wikis/pages?title=Quickstart_New&parent=)

#### 2、Maven插件命令

- 在`pom.xml`文件中添加插件配置（**必须**）：

    ```
    <plugin>
        <groupId>net.ymate.maven.plugins</groupId>
        <artifactId>ymate-maven-plugin</artifactId>
        <version>1.0-SNAPSHOT</version>
    </plugin>
    ```

- 执行命令格式：

    ```
    mvn ymate:<COMMAND> -D<PARAM_1>=<VALUE_1> -D<PARAM_n>=<VALUE_n>
    ```

    > 注：请在`pom.xml`文件所在路径下执行；

- 命令列表：

    |命令|说明|
    |---|---|
    |`module`|模块代码生成器|
    |`controller`|控制器类生成器|
    |`mapping`|控制器请求方法生成器|
    |`interceptor`|拦截器类生成器|
    |`validator`|验证器类生成器|
    |`repository`|存储器类生成器|
    |`service`|服务层类生成器|
    |`config`|配置类生成器|
    |`enpasswd`|字符串加密|
    |`depasswd`|字符串解密|
    |`tomcat`|Tomcat服务配置生成器|
    |`entity`|数据实体代码生成器|
    |`crud`|CRUD代码生成器|
    |`dbquery`|数据库SQL查询|
    |`init`|初始化基于YMP框架工程所需的各类配置文件及必要的目录结构|
    |`configuration`|配置体系目录结构生成器|

#### 2.1 插件命令详解

##### 2.1.1 `module`：模块代码生成器

> 用于生成基于`IModule`接口的模块代码实现（完全替代`ymate-archetype-module (module)`模板）；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|模块名称|
    |package|否|模块包名，默认值：`${project.groupId}.module`|

- 命令示例：

    > 创建名称为`Demo`的模块；

    执行命令：

    ```
    mvn ymate:module -Dname=Demo
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:module (default-cli) @ ympDemo ---
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/module/IDemo.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/module/Demo.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/module/IDemoModuleCfg.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/module/impl/DefaultModuleCfg.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.504s
    [INFO] Finished at: Tue Oct 31 17:12:56 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.2 `controller`：控制器类生成器

> 用于生成适用于WebMVC模块的控制器类代码；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|控制器名称|
    |package|否|控制器包名，默认值：`${project.groupId}.controller`|
    |suffix|否|控制器类名后缀，默认值：`Controller`|
    |singleton|否|控制器是否为单例，默认值：`true`|
    |transaction|否|是否添加事务注解，默认值：`false`|
    |mapping|否|控制器请求根路径，默认值：`空`|
    |mapping.method|否|控制器请求方式，默认值：`空`，多个用`,`分隔，取值范围：`GET`，`HEAD`，`POST`，`PUT`，`DELETE`，`OPTIONS`，`TRACE`|
    |mapping.header|否|控制器请求头，默认值：`空`，多个用`,`分隔|
    |mapping.param|否|控制器请求参数，默认值：`空`，多个用`,`分隔|

- 命令示例：

    > 创建名称为`DemoAction`的控制器类，内容如下：

    ```
    @Controller
    @RequestMapping(value = "/user/info", method = {Type.HttpMethod.POST, Type.HttpMethod.GET} )
    public class DemoAction {
    
        @RequestMapping("/")
        public IView __index() throws Exception {
            return View.textView("Hello YMPer!");
        }
    }
    ```

    执行命令：

    ```
    mvn ymate:controller -Dname=Demo -Dsuffix=Action -Dmapping=/user/info -Dmapping.method=post,get
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:controller (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--controllerName:DemoAction
    [INFO] 	|--packageName:net.ymate.demo.controller
    [INFO] 	|--singleton:true
    [INFO] 	|--transaction:false
    [INFO] 	|--mapping:/user/info
    [INFO] 	  |--method:POST
    [INFO] 	  |--method:GET
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/controller/DemoAction.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.377s
    [INFO] Finished at: Tue Oct 31 17:48:20 CST 2017
    [INFO] Final Memory: 8M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.3 `mapping`：控制器请求方法生成器

> 用于为指定的控制器类追加请求方法代码片段；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|控制器名称|
    |package|否|控制器包名，默认值：`${project.groupId}.controller`|
    |suffix|否|控制器类名后缀，默认值：`Controller`|
    |method|是|控制器方法名称|
    |method.param|否|控制器方法参数，默认值：`空`，多个用`,`分隔；可以通过`<取值方式>:<参数名称>`指定参数取值方式，取值方式包括：`path`，`header`，`cookie`，`model`，`file`|
    |fileUpload|否|是否添加@FileUpload注解|
    |transaction|否|是否添加事务注解，默认值：`false`|
    |mapping|否|控制器请求根路径，默认值：`空`|
    |mapping.method|否|控制器请求方式，默认值：`空`，多个用`,`分隔，取值范围：`GET`，`HEAD`，`POST`，`PUT`，`DELETE`，`OPTIONS`，`TRACE`|
    |mapping.header|否|控制器请求头，默认值：`空`，多个用`,`分隔|
    |mapping.param|否|控制器请求参数，默认值：`空`，多个用`,`分隔|

- 命令示例：

    > 为名称为`DemoAction`的控制器类添加`__sayHi`请求方法并添加`username`和`age`方法参数，其中`age`参数通过`@Pathvariable`注解获取，内容如下：

    ```
    @RequestMapping(value = "/sayHi/{age}" )
    public IView __sayHi(@RequestParam String username, @PathVariable String age) throws Exception {
        return View.textView("mapping: /sayHi/{age}");
    }
    ```

    执行命令：

    ```
    mvn ymate:mapping -Dname=Demo -Dsuffix=Action -Dmapping=/sayHi/{age} -Dmethod=sayHi -Dmethod.param=username,path:age
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:mapping (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--controllerName:DemoAction
    [INFO] 	|--fileUpload:false
    [INFO] 	|--transaction:false
    [INFO] 	|--method:__sayHi
    [INFO] 	  |--param:username
    [INFO] 	  |--param:path:age
    [INFO] 	|--mapping:/sayHi/{age}
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/controller/DemoAction.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.482s
    [INFO] Finished at: Wed Nov 01 22:27:58 CST 2017
    [INFO] Final Memory: 11M/309M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.4 `interceptor`：拦截器类生成器

> 用于生成拦截器类代码；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|拦截器名称|
    |package|否|拦截器包名，默认值：`${project.groupId}.intercept`|
    |suffix|否|拦截器类名后缀，默认值：`Interceptor`|

- 命令示例：

    > 创建名称为`DemoInterceptor`的拦截器，内容如下：

    ```
    public class DemoInterceptor extends AbstractInterceptor {
    
        @Override
        protected Object __before(InterceptContext context) throws Exception {
            return null;
        }
    
        @Override
        protected Object __after(InterceptContext context) throws Exception {
            return null;
        }
    }
    ```

    执行命令：

    ```
    mvn ymate:interceptor -Dname=Demo
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:interceptor (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--interceptorName:DemoInterceptor
    [INFO] 	|--packageName:net.ymate.demo.intercept
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/intercept/DemoInterceptor.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.421s
    [INFO] Finished at: Wed Nov 01 22:41:23 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.5 `validator`：验证器类生成器

> 用于生成验证器注解及类代码；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|验证器名称|
    |package|否|验证器包名，默认值：`${project.groupId}.validation`|
    |suffix|否|验证器类名后缀，默认值：`Validator`|

- 命令示例：

    > 创建名称为`VDemo`和`DemoValidator`的验证器注解和验证器类，内容如下：

    ```
    @Target({ElementType.FIELD, ElementType.PARAMETER})
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    public @interface VDemo {
    
        /**
         * @return 自定义验证消息
         */
        String msg() default "";
    }
    
    @Validator(VDemo.class)
    @CleanProxy
    public class DemoValidator extends AbstractValidator {
    
        @Override
        public ValidateResult validate(ValidateContext context) {
            Object _paramValue = context.getParamValue();
            if (_paramValue != null) {
                boolean _matched = false;
                VDemo _anno = (VDemo) context.getAnnotation();
    
                // TODO Code here.
    
                if (_matched) {
                    String _pName = StringUtils.defaultIfBlank(context.getParamLabel(), context.getParamName());
                    _pName = __doGetI18nFormatMessage(context, _pName, _pName);
                    String _msg = StringUtils.trimToNull(_anno.msg());
                    if (_msg != null) {
                        _msg = __doGetI18nFormatMessage(context, _msg, _msg, _pName);
                    }
                    return new ValidateResult(context.getParamName(), _msg);
                }
            }
            return null;
        }
    }
    ```

    执行命令：

    ```
    mvn ymate:validator -Dname=Demo
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:validator (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--validatorName:DemoValidator
    [INFO] 	|--packageName:net.ymate.demo.validation
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/validation/VDemo.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/validation/DemoValidator.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.438s
    [INFO] Finished at: Wed Nov 01 22:48:42 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.6 `repository`：存储器类生成器

> 用于生成存储器类代码；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|存储器名称|
    |package|否|存储器包名，默认值：`${project.groupId}.repository`|
    |suffix|否|存储器类名后缀，默认值：`Repository`|
    |transaction|否|是否添加事务注解，默认值：`false`|
    |config|否|是否启用配置对象，默认值：`false`|
    |interface|否|是否启用接口模式，默认值：`false`|

- 命令示例：

    > 创建名称为`DemoRepository`的存储器并启用配置对象和接口模式，内容如下：

    ```
    public interface IDemoRepository {
    
        IResultSet<Object[]> execSql(String hash, IResultSet<Object[]> results) throws Exception;
    
        List<Object[]> execQuery(String hash, IResultSet<Object[]>... results) throws Exception;
    }

    @Repository
    @Transaction
    public class DemoRepository implements IDemoRepository,  IRepository {
    
        @Inject
        private DemoRepositoryConfig __config;
    
        @Override
        public IConfiguration getConfig() {
            return __config;
        }
    
        /**
        * 自定义SQL
        */
        @Repository("select * from table1 where hash = ${hash}")
        public IResultSet<Object[]> execSql(String hash, IResultSet<Object[]> results) throws Exception {
            return results;
        }
    
        /**
        * 读取配置文件中的SQL
        */
        @Repository(item = "demo_query")
        public List<Object[]> execQuery(String hash, IResultSet<Object[]>... results) throws Exception {
            return results[0].getResultData();
        }
    }
    ```

    执行命令：

    ```
    mvn ymate:repository -Dname=Demo -Dtransaction=true -Dconfig=true -Dinterface=true
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:repository (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--repositoryName:DemoRepository
    [INFO] 	|--packageName:net.ymate.demo.repository
    [INFO] 	|--transaction:true
    [INFO] 	|--withConfig:true
    [INFO] 	|--withInterface:true
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/repository/IDemoRepository.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/repository/impl/DemoRepository.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.438s
    [INFO] Finished at: Wed Nov 01 23:36:27 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.7 `service`：服务层类生成器

> 用于生成服务层类代码；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|服务类名称|
    |package|否|服务类包名，默认值：`${project.groupId}.service`|
    |suffix|否|服务类名后缀，默认值：`Service`|
    |transaction|否|是否添加事务注解，默认值：`false`|

- 命令示例：

    > 创建名称为`DemoService`的服务类及接口，内容如下：

    ```
    public interface IDemoService {
    }

    @Bean
    public class DemoService implements IDemoService {
    }
    ```

    执行命令：

    ```
    mvn ymate:service -Dname=Demo
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:service (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--serviceName:DemoService
    [INFO] 	|--packageName:net.ymate.demo.service
    [INFO] 	|--transaction:false
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/service/IDemoService.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/service/impl/DemoService.java
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.425s
    [INFO] Finished at: Wed Nov 01 23:44:13 CST 2017
    [INFO] Final Memory: 10M/309M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.8 `config`：配置类生成器

> 用于生成基于YMP框架配置体系结构的配置类代码及相关配置文件；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |name|是|配置类名称|
    |home|否|配置体系根路径，WEB工程默认值：`/src/main/webapp/WEB-INF`，普通工程默认值：`/src/main/resources`|
    |properties|否|是否使用properties格式的配置文件，默认值：`false`|
    |file|否|自定义配置文件相对路径，默认值：`cfgs/<配置类名称>.cfg.<xml\|properties>`|
    |package|否|配置类包名，默认值：`${project.groupId}.config`|
    |suffix|否|配置类名后缀，默认值：`Config`|
    |interface|否|是否启用接口模式，默认值：false|

- 命令示例：

    > 创建名称为`DemoConfig`的配置类、接口和配置文件，内容如下：

    ```
    public interface IDemoConfig {
    }

    @Configuration("cfgs/demo.cfg.xml")
    public class DemoConfig extends DefaultConfiguration implements IDemoConfig {
    }

    // --- cfgs/demo.cfg.xml
    
    <?xml version="1.0" encoding="UTF-8"?>
    <!-- 用XML格式书写与configuration.properties相同的配置内容 -->
    <!-- XML根节点为properties, abc代表扩展属性key, xyz代表扩展属性值 -->
    <properties abc="xyz">
        <!-- 分类节点为category, 默认分类名称为default, abc代表扩展属性key, xyz代表扩展属性值 -->
        <category name="default" abc="xyz">
            <!-- 属性标签为property, name代表属性名称, value代表属性值(也可以用property标签包裹), abc代表扩展属性key, xyz代表扩展属性值 -->
            <property name="company_name" abc="xyz" value="Apple Inc."/>
            <!-- 用属性标签表示一个数组或集合数据类型的方法, abc代表扩展属性key, xyz代表扩展属性值, 这一点与properties配置文件不同 -->
            <property name="products" abc="xyz">
                <!-- 集合元素必须用value标签包裹, 且value标签不要包括任何扩展属性 -->
                <value>iphone</value>
                <value>ipad</value>
                <value>imac</value>
                <value>itouch</value>
            </property>
            <!-- 用属性标签表示一个MAP数据类型的方法, abc代表扩展属性key, xyz代表扩展属性值, 扩展属性与item将被合并处理  -->
            <property name="product_spec" abc="xzy">
                <!-- MAP元素用item标签包裹, 且item标签必须包含name扩展属性(其它扩展属性将被忽略), 元素值由item标签包裹 -->
                <item name="color">red</item>
                <item name="weight">120g</item>
                <item name="size">small</item>
                <item name="age">2015</item>
            </property>
        </category>
    </properties>
    ```

    执行命令：

    ```
    mvn ymate:config -Dname=Demo -Dinterface=true
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:config (default-cli) @ ympDemo ---
    [INFO] properties:
    [INFO] 	|--type:jar
    [INFO] 	|--configHome:/src/main/resources
    [INFO] 	|--configName:DemoConfig
    [INFO] 	|--packageName:net.ymate.demo.config
    [INFO] 	|--fileName:cfgs/demo.cfg.xml
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/config/IDemoConfig.java
    [INFO] Output file: /Users/.../ympDemo/src/main/java/net/ymate/demo/config/impl/DemoConfig.java
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/cfgs/demo.cfg.xml
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.434s
    [INFO] Finished at: Thu Nov 02 00:05:02 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.9 `enpasswd`：字符串加密

> 基于`IPasswordProcessor`密码处理器接口的默认`DES`实现，对数据库等登录密码进行加密操作；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |passwd|是|原始字符串|
    |passkey|否|自定义密钥|

- 命令示例：

    > 对字符串`abc12345678`进行加密：

    执行命令：

    ```
    mvn ymate:enpasswd -Dpasswd=abc12345678
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:enpasswd (default-cli) @ ympDemo ---
    [INFO] Use passkey: 16296b50a6db0d0bd45d2e5f84fcdd76
    [INFO] Encrypt password: D3ytOQrD63BlKGDMJnaYsQ==
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.515s
    [INFO] Finished at: Thu Nov 02 09:00:35 CST 2017
    [INFO] Final Memory: 11M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.10 `depasswd`：字符串解密

> 基于`IPasswordProcessor`密码处理器接口的默认`DES`实现，对数据库等登录密码进行解密操作；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |passwd|是|已加密字符串|
    |passkey|否|自定义密钥|

- 命令示例：

    > 对已加密字符串`D3ytOQrD63BlKGDMJnaYsQ==`进行解密：

    执行命令：

    ```
    mvn ymate:depasswd -Dpasswd=D3ytOQrD63BlKGDMJnaYsQ==
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:depasswd (default-cli) @ ympDemo ---
    [INFO] Use passkey: 16296b50a6db0d0bd45d2e5f84fcdd76
    [INFO] Decrypt password: abc12345678
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.459s
    [INFO] Finished at: Thu Nov 02 09:03:51 CST 2017
    [INFO] Final Memory: 11M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.11 `tomcat`：Tomcat服务配置生成器

> 生成基于Tomcat的获立JVM服务目录结构及配置文件，目前支持Tomcat版本：`6`、`7`、`8`、`9`；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |serviceName|是|服务名称（若在`Windows`环境下同时为注册服务名称）|
    |catalinaHome|是|Tomcat软件包安装路径，默认值：`${CATALINA_HOME}`|
    |catalinaBase|否|生成的服务存放的位置，默认值：`当前路径`|
    |hostName|否|主机名称，默认值：`localhost`|
    |hostAlias|否|别名，默认值：`空`|
    |tomcatVersion|否|指定Tomcat软件包的版本，默认值：`7`，目前支持：`6`，`7`，`8`，`9`，（必须与`catalinaHome`指定的版本匹配）|
    |serverPort|否|服务端口（Tomcat服务的Server端口），默认值：`8005`|
    |connectorPort|否|容器端口（Tomcat服务的Connector端口），默认值：`8080`|
    |ajp|否|是否启用AJP配置，默认值：`false`|
    |ajpHost|否|AJP主机名称，默认值：`localhost`|
    |ajpPort|否|AJP端口，默认值：`8009`|

- 命令示例：

    > 基于`Tomcat7.x`创建名称为`DemoServer`的服务：

    执行命令：

    ```
    mvn ymate:tomcat -DserviceName=DemoServer -DcatalinaHome=/Users/.../apache-tomcat-7.0.54 -DcatalinaBase=/Users/.../Temp
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:tomcat (default-cli) @ ympDemo ---
    [INFO] Tomcat Service:DemoServer
    [INFO] 	|--CatalinaHome:/Users/.../apache-tomcat-7.0.54
    [INFO] 	|--CatalinaBase:/Users/.../Temp
    [INFO] 	|--HostName:localhost
    [INFO] 	|--HostAlias:
    [INFO] 	|--TomcatVersion:7
    [INFO] 	|--ServerPort:8005
    [INFO] 	|--ConnectorPort:8080
    [INFO] 	|--RedirectPort:8443
    [INFO] 	|--Ajp:false
    [INFO] Output file: /Users/.../Temp/DemoServer/conf/server.xml
    [INFO] Output file: /Users/.../Temp/DemoServer/vhost.conf
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/install.bat
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/manager.bat
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/shutdown.bat
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/startup.bat
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/uninstall.bat
    [INFO] Output file: /Users/.../Temp/DemoServer/bin/manager.sh
    [INFO] Output file: /Users/.../Temp/DemoServer/webapps/ROOT/index.jsp
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.498s
    [INFO] Finished at: Thu Nov 02 10:05:47 CST 2017
    [INFO] Final Memory: 11M/309M
    [INFO] ------------------------------------------------------------------------
    ```

    生成的文件说明：

    |文件名称|说明|
    |---|---|
    |`conf/server.xml`|`Tomcat`服务配置文件|
    |`vhost.conf`|与`Nginx`和`Apache Server`整合所需配置|
    |`bin/install.bat`|`Windows`环境下服务安装|
    |`bin/manager.bat`|`Windows`环境下打开`Tomcat`服务管理|
    |`bin/shutdown.bat`|`Windows`环境下服务停止|
    |`bin/startup.bat`|`Windows`环境下服务启动|
    |`bin/uninstall.bat`|`Windows`环境下服务卸载|
    |`bin/manager.sh`|`Linux`或`Unix`环境下控制服务的启动或停止等操作|
    |`webapps/ROOT/index.jsp`|默认JSP首页文件|

    `Linux`下服务的启动和停止：
    
    - 需要为`manager.sh`添加执行权限：

        执行命令：

        ```
        chmod +x manager.sh
        ```

    - 启动服务：

        执行命令：
        
        ```
        ./manager.sh start
        ```

        控制台输出：

        ```
        Using CATALINA_BASE:   /Users/.../Temp/DemoServer
        Using CATALINA_HOME:   /Users/.../apache-tomcat-7.0.54
        Using CATALINA_TMPDIR: /Users/.../Temp/DemoServer/temp
        Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
        Using CLASSPATH:       /Users/.../apache-tomcat-7.0.54/bin/bootstrap.jar:/Users/.../apache-tomcat-7.0.54/bin/tomcat-juli.jar
        Using CATALINA_PID:    /Users/.../Temp/DemoServer/logs/catalina.pid
        Tomcat started.
        ```

    - 停止服务：

        执行命令：
        
        ```
        ./manager.sh stop
        ```

        控制台输出：

        ```
        Using CATALINA_BASE:   /Users/.../Temp/DemoServer
        Using CATALINA_HOME:   /Users/.../apache-tomcat-7.0.54
        Using CATALINA_TMPDIR: /Users/.../Temp/DemoServer/temp
        Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home
        Using CLASSPATH:       /Users/.../apache-tomcat-7.0.54/bin/bootstrap.jar:/Users/.../apache-tomcat-7.0.54/bin/tomcat-juli.jar
        Using CATALINA_PID:    /Users/.../Temp/DemoServer/logs/catalina.pid
        Tomcat stopped.
        ```

##### 2.1.12 `entity`：数据实体代码生成器

> 通过已有数据库表结构生成对应的数据实体类，支持表和视图，支持`ConsoleTable`和`markdown`格式输出表结构；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |view|否|指定本次针对视图生成代码，默认值：`false`|
    |markdown|否|是否采用`markdown`格式输出表结构，默认值：`false`|
    |csv|否|是否采用`csv`格式输出表结构，默认值：`false`|
    |onlyShow|否|不生成任何文件仅格式输出表结构，默认值：`false`|

- 数据源及生成规则配置：

    > 在生成数据实体之前，需要先将默认数据源和实体生成规则配置好，请根据实际需求配置并确认`ymp-conf.properties`以下内容：

    ```
    #-------------------------------------
    # JDBC持久化模块初始化参数
    #-------------------------------------

    # 是否显示执行的SQL语句，默认为false
    ymp.configs.persistence.jdbc.ds.default.show_sql=true

    # 数据库表前缀名称，默认为空
    ymp.configs.persistence.jdbc.ds.default.table_prefix=ym_

    # 数据库连接字符串，必填参数
    ymp.configs.persistence.jdbc.ds.default.connection_url=jdbc:mysql://localhost:3306/ymate_demo

    # 数据库访问用户名称，必填参数
    ymp.configs.persistence.jdbc.ds.default.username=root

    # 数据库访问密码，可选参数
    ymp.configs.persistence.jdbc.ds.default.password=

    #-------------------------------------
    # JDBC数据实体代码生成器配置参数
    #-------------------------------------
    
    # 是否生成新的BaseEntity类，默认为false(即表示使用框架提供的BaseEntity类)
    ymp.params.jdbc.use_base_entity=

    # 是否使用类名后缀，不使用和使用的区别如: User-->UserModel，默认为false
    ymp.params.jdbc.use_class_suffix=

    # 是否采用链式调用模式，默认为false
    ymp.params.jdbc.use_chain_mode=

    # 是否添加类成员属性值状态变化注解，默认为false
    ymp.params.jdbc.use_state_support=

    # 实体及属性命名过滤器接口实现类，默认为空
    ymp.params.jdbc.named_filter_class=

    # 数据库名称(仅针对特定的数据库使用，如Oracle)，默认为空
    ymp.params.jdbc.db_name=

    # 数据库用户名称(仅针对特定的数据库使用，如Oracle)，默认为空
    ymp.params.jdbc.db_username=

    # 数据库表名称前缀，多个用'|'分隔，默认为空
    ymp.params.jdbc.table_prefix=

    # 否剔除生成的实体映射表名前缀，默认为false
    ymp.params.jdbc.remove_table_prefix=

    # 预生成实体的数据表名称列表，多个用'|'分隔，默认为空表示全部生成
    ymp.params.jdbc.table_list=

    # 排除的数据表名称列表，在此列表内的数据表将不被生成实体，多个用'|'分隔，默认为空
    ymp.params.jdbc.table_exclude_list=

    # 需要添加@Readonly注解声明的字段名称列表，多个用'|'分隔，默认为空
    ymp.params.jdbc.readonly_field_list=

    # 生成的代码文件输出路径，默认为${root}
    ymp.params.jdbc.output_path=

    # 生成的代码所属包名称，默认为: packages
    ymp.params.jdbc.package_name=
    ```

- 命令示例：

    执行命令：

    ```
    mvn ymate:entity
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building carfriend-core 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:entity (default-cli) @ carfriend-core ---
    十一月 02, 2017 11:41:09 上午 net.ymate.platform.core.YMP init
    信息:
    __   ____  __ ____          ____
    \ \ / /  \/  |  _ \  __   _|___ \
     \ V /| |\/| | |_) | \ \ / / __) |
      | | | |  | |  __/   \ V / / __/
      |_| |_|  |_|_|       \_/ |_____|  Website: http://www.ymate.net/
    十一月 02, 2017 11:41:09 上午 net.ymate.platform.core.YMP init
    信息: Initializing ymate-platform-core-2.0.2-Release build-20171030-0108 - debug:true
    十一月 02, 2017 11:41:09 上午 net.ymate.platform.persistence.jdbc.JDBC init
    信息: Initializing ymate-platform-persistence-jdbc-2.0.2-Release build-20171030-0108
    十一月 02, 2017 11:41:09 上午 net.ymate.platform.core.YMP init
    信息: Initialization completed, Total time: 191ms
    十一月 02, 2017 11:41:09 上午 net.ymate.platform.persistence.jdbc.base.AbstractOperator execute
    信息: [show full tables where Table_type='BASE TABLE'][][1][31ms]
    Output file /Users/.../src/main/java/net/ymate/model/CategoryAttribute.java
    TABLE_NAME: ym_category_attribute
    MODEL_NAME: CategoryAttribute
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | COLUMN_NAME | COLUMN_CLASS_NAME | PRIMARY_KEY | AUTO_INCREMENT | SIGNED | PRECISION | SCALE | NULLABLE | DEFAULT | REMARKS |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | id          | java.lang.String  | TRUE        | FALSE          | FALSE  | 32        | 0     | FALSE    | NULL    |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | catetory_id | java.lang.String  | FALSE       | FALSE          | FALSE  | 32        | 0     | FALSE    | NULL    |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | attr_key    | java.lang.String  | FALSE       | FALSE          | FALSE  | 255       | 0     | FALSE    | NULL    |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | attr_value  | java.lang.String  | FALSE       | FALSE          | FALSE  | 16383     | 0     | TRUE     | NULL    |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | type        | java.lang.Integer | FALSE       | FALSE          | FALSE  | 2         | 0     | TRUE     | 0       |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+
    | owner       | java.lang.String  | FALSE       | FALSE          | FALSE  | 32        | 0     | TRUE     | NULL    |         |
    +-------------+-------------------+-------------+----------------+--------+-----------+-------+----------+---------+---------+


    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 1.013s
    [INFO] Finished at: Thu Nov 02 11:41:10 CST 2017
    [INFO] Final Memory: 12M/208M
    [INFO] ------------------------------------------------------------------------
    ```

- 特别提示：

    > 通过插件生成的代码默认放置在`src/main/java`路径，当数据库表发生变化时，直接执行插件命令就可以快速更新数据实体对象；
    > 
    > 如果使用的JDBC驱动是`mysql-connector-java-6.x`及以上版本时，需要配置`db_name`和`db_username`参数，否则会产生异常；

##### 2.1.13 `crud`：CRUD代码生成器

> 通过规则配置文件自动生成控制器（`Controller`）、存储器（`Repository`）和页面视图(`View`)等代码，包括拦截器、参数验证、权限控制、文件上传、组件条件查询等；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |file|否|CRUD规则配置文件，默认值：`misc/crud.json`|
    |action|否|指定本次生成哪些代码，默认值：`全部`，取值范围：`controller`，`repository`，`view`|
    |filter|否|指定本次仅生成列表中API或表的代码，默认值：`空`，多个名称之间用`,`分隔|
    |fromDb|否|是否通过数据库表结构生成规则配置文件，默认值：`false`|
    |formBean|否|是否将请求参数封装成JavaBean，默认值：`false`|
    |repositoryWithoutFormBean|否|是否禁止存储器使用JavaBean封装参数，默认值：`false`|
    |withDoc|否|是否生成API文档注解，默认值：`false`|
    |mapping|否|指定生成的控制器基准`RequestMapping`路径，默认值：`空`|
    |package|否|指定生成类包名，默认值：`${project.groupId}`|

- 命令示例：

    > 生成默认CRUD规则配置文件：

    执行命令：

    ```
    mvn ymate:crud
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:crud (default-cli) @ ympDemo ---
    [INFO] Output file: /Users/.../Temp/ympDemo/misc/crud.json
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.424s
    [INFO] Finished at: Thu Nov 02 12:12:17 CST 2017
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

    > 若使用`-DfromDb=true`方式通过数据库表结构生成规则配置文件，需要在`ymp-conf.properties`文件中配置好默认数据源；
    >
    > 以上命令在执行时，若`crud.json`配置文件存在则直接生成代码，否则将生成默认配置文件，内容如下：

    规则配置文件说明：

    
    ```
    {                                       // ————基本信息
        "name": "ympDemo",                  // 名称
        "version": "1.0-SNAPSHOT",          // 当前配置版本
        "package": "net.ymate.demo",        // 代码基准包名
        "author": "ymatescaffold",          // 作者信息
        "createTime": "2017/11/02 12:12",   // 配置文件创建时间
        "locked": false,                    // 是否锁定，锁定状态下不会生成任何文件
        "security": {               // ————权限安全相关配置
            "enabled": false,       // 是否开启权限配置
            "name": "",             // 权限组名称
            "prefix": "",           // 权限名称前缀
            "roles": {              // 基本角色配置
                "admin": false,     // 是否管理员角色
                "operator": false,  // 是否操作员角色
                "user": false       // 是否普通用户角色
            },
            "permissions": []       // 全局权限列表，如：["USER_ADD", "USER_DETAIL"]
        },
        "intercept": {      // ————拦截器相关配置
            "before": [],   // 前置拦截器类名集合，如：["net.ymate.demo.intercept.UserInterceptor"]
            "after": [],    // 后置拦截器类名集合
            "around": [],   // 环绕（前、后置）拦截器类名集合
            "params": {}    // 拦截器参数，如：{"p1": "p1_value"}
        },
        "apis": [                               // ————接口对象相关配置
            {
                "name": "",                     // 当前接口对象名称，如：”user“
                "mapping": "",                  // 当前控制器类基准URL路径，如："/v1/user"
                "type": "model",                // 生成类型，取值范围：model，query
                "model": "",                    // 数据实体类名，当type="model"时必填，如："net.ymate.model.User"
                "query": "",                    // SQL查询语句，当type="query"时必填
                "description": "",              // 文档描述
                "locked": false,                // 是否锁定，锁定状态下忽略当前配置的代码生成
                "timestamp": false,             // 是否包含create_time字段
                "updateDisabled": false,        // 是否生成更新操作代码(需包含last_modify_time字段)
                "status": [                     // ————自定义数据状态处理相关配置
                    {
                        "enabled": false,       // 是否生成此状态配置代码
                        "name": "delete",       // 名称（用于生成方法名称）
                        "column": "is_deleted", // 对应的数据表字段名称
                        "type": "integer",      // 数据类型，常用string，integer，long等对象类型
                        "value": "1",           // 本次操作将变更字段的值
                        "reason": false,        // 是否必须提交操作原因说明参数
                        "description": ""       // 文档描述
                    }
                ],
                "primary": {                // ——主键参数
                    "name": "",             // 参数名称
                    "label": "",            // 参数标签名称（用于显示）
                    "column": "",           // 参数对应的数据表字段名称
                    "type": "string",       // 数据类型，常用string，integer，long等对象类型
                    "validation": {         // ————参数验证相关配置
                        "max": 0,           // 参数最大长度
                        "min": 0,           // 参数最小长度
                        "regex": "",        // 正则表达式
                        "numeric": false    // 是否必须为数值
                    },
                    "description": ""       // 参数文档描述
                },
                "params": [                     // ————参数集合
                    {
                        "name": "",             // 参数名称
                        "label": "",            // 参数标签名称（用于显示）
                        "column": "",           // 参数对应的数据表字段名称
                        "type": "string",       // 数据类型，常用string，integer，long等对象类型
                        "required": false,      // 是否必须
                        "defaultValue": "",     // 参数默认值
                        "validation": {         // ————参数验证相关配置
                            "max": 0,           // 参数最大长度
                            "min": 0,           // 参数最小长度
                            "regex": "",        // 正则表达式
                            "mobile": false,    // 是否必须为手机号码格式
                            "email": false,     // 是否必须为邮箱地址格式
                            "numeric": false,   // 是否必须为数值
                            "datetime": false   // 是否必须为日期时间戳
                        },
                        "filter": {             // ————查询相关配置
                            "enabled": false,   // 是否作为查询条件
                            "like": false,      // 是否采用like进行查询（自动为参数值两端添加"%"）
                            "region": false     // 是否采用between进行范围查询（一般用于数值和时间参数）
                        },
                        "upload": {             // ————文件上传相关配置
                            "enabled": false,   // 是否接收上传文件
                            "contentTypes": []  // 上传文件类型，如：["image/png", "image/jpeg"]
                        },
                        "description": ""       // 参数文档描述
                    }
                ]
            }
        ]
    }
    ```
##### 2.1.14 `dbquery`：数据库SQL查询

> 执行指定的SQL查询语句并支持以`ConsoleTable`、`Markdown`或`CSV`格式输出结果集；

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |sql|是|SQL查询语句|
    |format|否|输出格式，可选值：`table`，`markdown`，`csv`，默认值：`table`|
    |escape|否|列内容换行符是否转义|
    |page|否|查询页号，默认值：`0`|
    |pageSize|否|分页大小，默认值：`20`|

- 数据源及生成规则配置：

    > 在执行数据库SQL查询之前，需要先将默认数据源配置好，请根据实际需求配置并确认`ymp-conf.properties`以下内容：

    ```
    #-------------------------------------
    # JDBC持久化模块初始化参数
    #-------------------------------------

    # 是否显示执行的SQL语句，默认为false
    ymp.configs.persistence.jdbc.ds.default.show_sql=true

    # 数据库表前缀名称，默认为空
    ymp.configs.persistence.jdbc.ds.default.table_prefix=ym_

    # 数据库连接字符串，必填参数
    ymp.configs.persistence.jdbc.ds.default.connection_url=jdbc:mysql://localhost:3306/ymate_demo

    # 数据库访问用户名称，必填参数
    ymp.configs.persistence.jdbc.ds.default.username=root

    # 数据库访问密码，可选参数
    ymp.configs.persistence.jdbc.ds.default.password=
    ```

- 命令示例：

    执行命令：

    ```
    mvn ymate:dbquery -Dsql="select * from ym_user" -Dpage=1 -Dformat=csv
    ```

    控制台输出：

    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:dbquery (default-cli) @ ympDemo ---
    [INFO] SQL: select * from ym_user
    Mar 27, 2018 10:15:36 PM net.ymate.platform.core.YMP init
    信息:
    __   ____  __ ____          ____
    \ \ / /  \/  |  _ \  __   _|___ \
     \ V /| |\/| | |_) | \ \ / / __) |
      | | | |  | |  __/   \ V / / __/
      |_| |_|  |_|_|       \_/ |_____|  Website: http://www.ymate.net/
    Mar 27, 2018 10:15:36 PM net.ymate.platform.core.YMP init
    信息: Initializing ymate-platform-core-2.0.5-Release build-20180327-2036 - debug:true - env:unknown
    Mar 27, 2018 10:15:36 PM net.ymate.platform.persistence.jdbc.JDBC init
    信息: Initializing ymate-platform-persistence-jdbc-2.0.5-Release build-20180327-2036
    Mar 27, 2018 10:15:36 PM net.ymate.platform.persistence.Persistence init
    信息: Initializing ymate-platform-persistence-2.0.5-Release build-20180327-2036
    Mar 27, 2018 10:15:36 PM net.ymate.platform.core.YMP init
    信息: Initialization completed, Total time: 241ms
    Mar 27, 2018 10:15:36 PM net.ymate.platform.persistence.jdbc.base.AbstractOperator execute
    信息: [SELECT count(1) FROM (select * from ym_user) c_t][][1][9ms]
    Mar 27, 2018 10:15:36 PM net.ymate.platform.persistence.jdbc.base.AbstractOperator execute
    信息: [select * from ym_user limit 0, 20][][0][1ms]
    [INFO] ------------------------------------------------------------------------
    [INFO] Record count: 0
    [INFO] Current page: 1/0 - 20
    [INFO] ------------------------------------------------------------------------
    
    // Empty... :p
    
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.937s
    [INFO] Finished at: Tue Mar 27 22:15:36 CST 2018
    [INFO] Final Memory: 10M/245M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.15 `init`：初始化基于YMP框架工程所需的各类配置文件及必要的目录结构

- 命令示例：

    执行命令：

    ```
    mvn ymate:init -Doverwrite=true
    ```

    控制台输出：
    
    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:init (default-cli) @ ympDemo ---
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/c3p0.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/dbcp.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/ehcache.xml
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/simplelog.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/simplelogger.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/resources/ymp-conf.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/web.xml
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/cfgs/log4j.xml
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/logs/.log
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/templates/.tmpl
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/i18n/messages.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/i18n/messages_zh_CN.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/i18n/validation.properties
    [INFO] Output file: /Users/.../ympDemo/src/main/webapp/WEB-INF/i18n/validation_zh_CN.properties
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.499s
    [INFO] Finished at: Wed Apr 25 02:45:04 CST 2018
    [INFO] Final Memory: 11M/309M
    [INFO] ------------------------------------------------------------------------
    ```

##### 2.1.16 `configuration`：配置体系目录结构生成器

- 参数列表：

    |参数名称|必须|说明|
    |---|---|---|
    |homeDir|否|配置体系根路径，默认为当前项目基准路径，若指定路径不存在则创建之|
    |projectName|否|项目名称，默认值：`空`|
    |moduleNames|否|模块名称集合，默认值：`空`，多个用`,`分隔|
    |pluginNames|否|插件名称集合，默认值：`空`，多个用`,`分隔|
    |repair|否|是否执行缺失文件修复(除目录结构自动补全外，该参数将对缺失的文件进行补全)，默认值：false|

- 命令示例：

    执行命令：

    ```
    mvn ymate:configuration -DprojectName=default -DmoduleNames=webapp,demo -Drepair=true
    ```

    控制台输出：
    
    ```
    Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
    [INFO] Scanning for projects...
    [INFO]
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ympDemo 1.0-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO]
    [INFO] --- ymate-maven-plugin:1.0-SNAPSHOT:configuration (default-cli) @ ympDemo ---
    [INFO] Base directory: /Users/.../ympDemo
    [INFO] Create directory: /Users/.../ympDemo/bin
    [INFO] Create directory: /Users/.../ympDemo/dist
    [INFO] Create directory: /Users/.../ympDemo/projects
    [INFO] Create directory: /Users/.../ympDemo/cfgs
    [INFO] Create directory: /Users/.../ympDemo/classes
    [INFO] Create directory: /Users/.../ympDemo/lib
    [INFO] Create directory: /Users/.../ympDemo/logs
    [INFO] Create directory: /Users/.../ympDemo/temp
    [INFO] Output file: /Users/.../ympDemo/cfgs/log4j.xml
    [INFO] Create directory: /Users/.../ympDemo/projects/default/cfgs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/classes
    [INFO] Create directory: /Users/.../ympDemo/projects/default/lib
    [INFO] Create directory: /Users/.../ympDemo/projects/default/logs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/temp
    [INFO] Output file: /Users/.../ympDemo/projects/default/cfgs/log4j.xml
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/webapp/cfgs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/webapp/classes
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/webapp/lib
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/webapp/logs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/webapp/temp
    [INFO] Output file: /Users/.../ympDemo/projects/default/modules/webapp/cfgs/log4j.xml
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/demo/cfgs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/demo/classes
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/demo/lib
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/demo/logs
    [INFO] Create directory: /Users/.../ympDemo/projects/default/modules/demo/temp
    [INFO] Output file: /Users/.../ympDemo/projects/default/modules/demo/cfgs/log4j.xml
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 0.458s
    [INFO] Finished at: Fri May 18 11:56:20 CST 2018
    [INFO] Final Memory: 9M/245M
    [INFO] ------------------------------------------------------------------------
    ```

#### One More Thing

YMP不仅提供便捷的Web及其它Java项目的快速开发体验，也将不断提供更多丰富的项目实践经验。

感兴趣的小伙伴儿们可以加入 官方QQ群480374360，一起交流学习，帮助YMP成长！

了解更多有关YMP框架的内容，请访问官网：http://www.ymate.net/
