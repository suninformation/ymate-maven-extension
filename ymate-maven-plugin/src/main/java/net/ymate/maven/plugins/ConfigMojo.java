/*
 * Copyright 2007-2016 the original author or authors.
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
import java.util.HashMap;
import java.util.Map;

/**
 * 配置类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/26 上午12:10
 * @version 1.0
 */
@Mojo(name = "config")
public class ConfigMojo extends AbstractTmplMojo {

    /**
     * 配置体系根路径
     */
    @Parameter(property = "home")
    private String configHome;

    /**
     * 配置类名称
     */
    @Parameter(property = "name", required = true)
    private String configName;

    /**
     * 自定义配置文件相对路径
     */
    @Parameter(property = "file")
    private String fileName;

    /**
     * 配置类存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.config")
    private String packageName;

    /**
     * 配置类后缀, 默认为XxxxConfig
     */
    @Parameter(property = "suffix", defaultValue = "Config")
    private String suffix;

    @Parameter(property = "properties")
    private boolean properties;

    /**
     * 用于判断当前工程类型: jar或war
     */
    @Parameter(defaultValue = "${project.packaging}")
    private String type;

    /**
     * 是否启用接口模式
     */
    @Parameter(property = "interface")
    private boolean withInterface;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        boolean _absolutePath = false;
        if (StringUtils.isBlank(configHome)) {
            if (StringUtils.equalsIgnoreCase(type, "war")) {
                configHome = "/src/main/webapp/WEB-INF";
            } else {
                configHome = "/src/main/resources";
            }
        } else if (!new File(configHome).isAbsolute()) {
            throw new MojoFailureException("configHome must be absolute path.");
        } else {
            _absolutePath = true;
        }
        //
        String _configName = configName.concat(suffix);
        //
        if (StringUtils.isNotBlank(fileName) && !StringUtils.startsWith(fileName, "cfgs/")) {
            if (fileName.charAt(0) != '/') {
                fileName = "cfgs/" + fileName;
            } else {
                fileName += "cfgs" + fileName;
            }
        }
        //
        if (StringUtils.isBlank(fileName)) {
            fileName = "cfgs/" + configName.toLowerCase() + ".cfg";
            if (properties) {
                fileName += ".properties";
            } else {
                fileName += ".xml";
            }
        }
        //
        _props.put("configHome", configHome);
        _props.put("configName", _configName);
        _props.put("packageName", packageName);
        _props.put("fileName", fileName);
        _props.put("withInterface", withInterface);
        _props.put("isXml", !properties);

        getLog().info("properties:");
        getLog().info("\t|--type:" + type);
        getLog().info("\t|--configHome:" + configHome);
        getLog().info("\t|--configName:" + _configName);
        getLog().info("\t|--packageName:" + packageName);
        getLog().info("\t|--fileName:" + fileName);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        String _targetFileName = StringUtils.capitalize(_configName.concat(".java"));
        if (withInterface) {
            __doWriteSingleFile(new File(_path, "I".concat(_targetFileName)), "config-interface-tmpl", _props);
            __doWriteSingleFile(new File(_path, "impl/".concat(_targetFileName)), "config-tmpl", _props);
        } else {
            __doWriteSingleFile(new File(_path, _targetFileName), "config-tmpl", _props);
        }
        __doWriteSingleFile(new File((_absolutePath ? "" : basedir) + configHome, fileName), "config-file-tmpl", _props);
    }
}
