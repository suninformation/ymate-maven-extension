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

import net.ymate.platform.core.util.RuntimeUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.util.Collections;

/**
 * 配置体系目录结构生成器
 *
 * @author 刘镇 (suninformation@163.com) on 2018/5/18 上午10:23
 * @version 1.0
 */
@Mojo(name = "configuration")
public class ConfigurationMojo extends AbstractTmplMojo {

    /**
     * 配置体系目录结构
     */
    private static String[] __HOME_BASE_DIRS = new String[]{
            "cfgs",
            "classes",
            "lib",
            "logs",
            "temp"
    };

    private static String[] __HOME_EXTEND_DIRS = new String[]{
            "bin",
            "dist",
            "projects"
    };

    /**
     * 配置体系根路径，默认为当前项目基准路径，若指定路径不存在则创建之
     */
    @Parameter(property = "homeDir", defaultValue = "${basedir}")
    private String homeDir;

    /**
     * 项目名称
     */
    @Parameter(property = "projectName")
    private String projectName;

    /**
     * 模块名称集合
     */
    @Parameter(property = "moduleNames")
    private String[] moduleNames;

    /**
     * 插件名称集合
     */
    @Parameter(property = "pluginNames")
    private String[] pluginNames;

    /**
     * 是否执行缺失文件修复(除目录结构自动补全外，该参数将对缺失的文件进行补全)
     */
    @Parameter(property = "repair")
    private boolean repair;

    private void __doMakeDirs(File parent, boolean home) throws Exception {
        if (home) {
            for (String _dirName : __HOME_EXTEND_DIRS) {
                File _targetDir = new File(parent, _dirName);
                if (_targetDir.mkdirs()) {
                    getLog().info("Create directory: " + _targetDir.getPath());
                }
            }
        }
        for (String _dirName : __HOME_BASE_DIRS) {
            File _targetDir = new File(parent, _dirName);
            if (_targetDir.mkdirs()) {
                getLog().info("Create directory: " + _targetDir.getPath());
            }
        }
    }

    private void __repairLog4jFile(File baseDir) {
        if (repair) {
            __doWriteSingleFile(new File(baseDir, "cfgs/log4j.xml"), "init/log4j.xml", Collections.<String, Object>emptyMap());
        }
    }

    public void execute() throws MojoExecutionException, MojoFailureException {
        try {
            File _baseDir = new File(basedir);
            getLog().info("Base directory: " + _baseDir.getPath());
            __doMakeDirs(_baseDir, true);
            __repairLog4jFile(_baseDir);
            //
            if (StringUtils.isNotBlank(projectName)) {
                File _projectDir = new File(new File(_baseDir, "projects"), projectName);
                __doMakeDirs(_projectDir, false);
                __repairLog4jFile(_projectDir);
                //
                if (!ArrayUtils.isEmpty(moduleNames)) {
                    for (String _mName : moduleNames) {
                        File _moduleDir = new File(new File(_projectDir, "modules"), _mName);
                        __doMakeDirs(_moduleDir, false);
                        __repairLog4jFile(_moduleDir);
                        //
                        if (!ArrayUtils.isEmpty(pluginNames)) {
                            for (String _pName : pluginNames) {
                                File _pluginDir = new File(new File(_moduleDir, "plugins"), _pName);
                                __doMakeDirs(_pluginDir, false);
                            }
                        }
                    }
                } else if (!ArrayUtils.isEmpty(pluginNames)) {
                    for (String _pName : pluginNames) {
                        File _pluginDir = new File(new File(_projectDir, "plugins"), _pName);
                        __doMakeDirs(_pluginDir, false);
                    }
                }
            } else if (!ArrayUtils.isEmpty(pluginNames)) {
                for (String _pName : pluginNames) {
                    File _pluginDir = new File(new File(_baseDir, "plugins"), _pName);
                    __doMakeDirs(_pluginDir, false);
                }
            }
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        }
    }
}
