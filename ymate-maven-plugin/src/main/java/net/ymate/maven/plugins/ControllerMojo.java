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
 * 控制器类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/25 下午9:30
 * @version 1.0
 */
@Mojo(name = "controller")
public class ControllerMojo extends AbstractTmplMojo {

    /**
     * 控制器名称
     */
    @Parameter(property = "name", required = true)
    private String controllerName;

    /**
     * 控制器存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.controller")
    private String packageName;

    /**
     * 控制器后缀, 默认为XxxxController
     */
    @Parameter(property = "suffix", defaultValue = "Controller")
    private String suffix;

    /**
     * 控制器是否为单例, 默认为true
     */
    @Parameter(property = "singleton", defaultValue = "true")
    private boolean singleton;

    /**
     * 是否添加@Transaction注解
     */
    @Parameter(property = "transaction")
    private boolean transaction;

    /**
     * 控制器请求根路径
     */
    @Parameter(property = "mapping")
    private String mapping;

    /**
     * 控制器请求方法
     */
    @Parameter(property = "mapping.method")
    private String[] mappingMethod;

    /**
     * 控制器请求头
     */
    @Parameter(property = "mapping.header")
    private String[] mappingHeader;

    /**
     * 控制器请求参数
     */
    @Parameter(property = "mapping.param")
    private String[] mappingParam;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _controllerName = controllerName.concat(suffix);
        //
        _props.put("controllerName", _controllerName);
        _props.put("packageName", packageName);
        _props.put("singleton", singleton);
        _props.put("transaction", transaction);

        getLog().info("properties:");
        getLog().info("\t|--controllerName:" + _controllerName);
        getLog().info("\t|--packageName:" + packageName);
        getLog().info("\t|--singleton:" + singleton);
        getLog().info("\t|--transaction:" + transaction);

        Map<String, Object> _mapping = new HashMap<String, Object>();
        _mapping.put("mapping", mapping);
        _mapping.put("method", mappingMethod);
        _mapping.put("header", mappingHeader);
        _mapping.put("param", mappingParam);
        //
        _props.put("mapping", _mapping);
        //
        if (StringUtils.isNotBlank(mapping)) {
            getLog().info("\t|--mapping:" + mapping);
            for (String _v : mappingMethod) {
                getLog().info("\t  |--method:" + _v.toUpperCase());
            }
            for (String _v : mappingHeader) {
                getLog().info("\t  |--header:" + _v);
            }
            for (String _v : mappingParam) {
                getLog().info("\t  |--param:" + _v);
            }
        }
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        __doWriteSingleFile(new File(_path, StringUtils.capitalize(_controllerName.concat(".java"))), "controller-tmpl", _props);
    }
}
