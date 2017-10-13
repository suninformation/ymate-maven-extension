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
 * 存储器类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午3:06
 * @version 1.0
 */
@Mojo(name = "repository")
public class RepositoryMojo extends AbstractTmplMojo {

    /**
     * 存储器名称
     */
    @Parameter(property = "name", required = true)
    private String repositoryName;

    /**
     * 存储器存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.repository")
    private String packageName;

    /**
     * 存储器后缀, 默认为XxxxRepository
     */
    @Parameter(property = "suffix", defaultValue = "Repository")
    private String suffix;

    @Parameter(property = "transaction")
    private boolean transaction;

    /**
     * 是否启用配置对象
     */
    @Parameter(property = "config")
    private boolean withConfig;

    /**
     * 是否启用接口模式
     */
    @Parameter(property = "interface")
    private boolean withInterface;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _repositoryName = repositoryName.concat(suffix);
        //
        _props.put("repositoryName", _repositoryName);
        _props.put("packageName", packageName);
        _props.put("transaction", transaction);
        _props.put("withConfig", withConfig);
        _props.put("withInterface", withInterface);

        getLog().info("properties:");
        getLog().info("\t|--repositoryName:" + _repositoryName);
        getLog().info("\t|--packageName:" + packageName);
        getLog().info("\t|--transaction:" + transaction);
        getLog().info("\t|--withConfig:" + withConfig);
        getLog().info("\t|--withInterface:" + withInterface);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        //
        String _targetFileName = StringUtils.capitalize(_repositoryName.concat(".java"));
        if (withInterface) {
            __doWriteSingleFile(new File(_path, "I".concat(_targetFileName)), "repository-interface-tmpl", _props);
            __doWriteSingleFile(new File(_path, "impl/".concat(_targetFileName)), "repository-tmpl", _props);
        } else {
            __doWriteSingleFile(new File(_path, _targetFileName), "repository-tmpl", _props);
        }
    }
}
