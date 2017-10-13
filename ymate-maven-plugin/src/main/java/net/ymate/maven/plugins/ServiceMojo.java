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
 * 服务类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午3:06
 * @version 1.0
 */
@Mojo(name = "service")
public class ServiceMojo extends AbstractTmplMojo {

    /**
     * 服务类名称
     */
    @Parameter(property = "name", required = true)
    private String serviceName;

    /**
     * 服务类存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.service")
    private String packageName;

    /**
     * 服务类后缀, 默认为XxxxService
     */
    @Parameter(property = "suffix", defaultValue = "Service")
    private String suffix;

    @Parameter(property = "transaction")
    private boolean transaction;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _serviceName = serviceName.concat(suffix);
        //
        _props.put("serviceName", _serviceName);
        _props.put("packageName", packageName);
        _props.put("transaction", transaction);

        getLog().info("properties:");
        getLog().info("\t|--serviceName:" + _serviceName);
        getLog().info("\t|--packageName:" + packageName);
        getLog().info("\t|--transaction:" + transaction);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        //
        String _targetFileName = StringUtils.capitalize(_serviceName.concat(".java"));
        __doWriteSingleFile(new File(_path, "I".concat(_targetFileName)), "service-interface-tmpl", _props);
        __doWriteSingleFile(new File(_path, "impl/".concat(_targetFileName)), "service-tmpl", _props);
    }
}
