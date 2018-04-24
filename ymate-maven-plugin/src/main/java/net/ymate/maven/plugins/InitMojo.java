/*
 * Copyright 2007-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.ymate.maven.plugins;

import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * 初始化基于YMP框架工程所需的各类配置文件及必要的目录结构
 *
 * @author 刘镇 (suninformation@163.com) on 2018/4/17 上午2:10
 * @version 1.0
 */
@Mojo(name = "init")
public class InitMojo extends AbstractTmplMojo {

    /**
     * 用于判断当前工程类型: jar或war
     */
    @Parameter(defaultValue = "${project.packaging}")
    private String type;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _params = new HashMap<String, Object>();
        _params.put("packageBase", packageBase);
        if (StringUtils.equals(type, "jar")) {
            File _path = new File(basedir, "/src/main/resources");
            __doWriteSingleFile(new File(_path, "c3p0.properties"), "init/c3p0.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "dbcp.properties"), "init/dbcp.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "ehcache.xml"), "init/ehcache.xml", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "cfgs/log4j.xml"), "init/log4j.xml", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "logs/.log"), "init/empty", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "messages.properties"), "init/messages.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "messages_zh_CN.properties"), "init/messages_zh_CN.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "validation.properties"), "init/validation.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "validation_zh_CN.properties"), "init/validation_zh_CN.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "simplelog.properties"), "init/simplelog.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "simplelogger.properties"), "init/simplelogger.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "ymp-conf.properties"), "init/ymp-conf.properties", _params);
        } else if (StringUtils.equals(type, "war")) {
            File _path = new File(basedir, "/src/main/resources");
            __doWriteSingleFile(new File(_path, "c3p0.properties"), "init/c3p0.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "dbcp.properties"), "init/dbcp.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "ehcache.xml"), "init/ehcache.xml", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "simplelog.properties"), "init/simplelog.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "simplelogger.properties"), "init/simplelogger.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "ymp-conf.properties"), "init/ymp-conf.properties", _params);
            //
            _path = new File(basedir, "/src/main/webapp/WEB-INF");
            __doWriteSingleFile(new File(_path, "web.xml"), "init/web.xml", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "cfgs/log4j.xml"), "init/log4j.xml", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "logs/.log"), "init/empty", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "templates/.tmpl"), "init/empty", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "i18n/messages.properties"), "init/messages.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "i18n/messages_zh_CN.properties"), "init/messages_zh_CN.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "i18n/validation.properties"), "init/validation.properties", Collections.<String, Object>emptyMap());
            __doWriteSingleFile(new File(_path, "i18n/validation_zh_CN.properties"), "init/validation_zh_CN.properties", Collections.<String, Object>emptyMap());
        }
    }
}
