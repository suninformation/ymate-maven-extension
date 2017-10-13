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
 * 拦截器类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午4:27
 * @version 1.0
 */
@Mojo(name = "interceptor")
public class InterceptorMojo extends AbstractTmplMojo {

    /**
     * 拦截器名称
     */
    @Parameter(property = "name", required = true)
    private String interceptorName;

    /**
     * 拦截器存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.intercept")
    private String packageName;

    /**
     * 拦截器后缀, 默认为XxxxInterceptor
     */
    @Parameter(property = "suffix", defaultValue = "Interceptor")
    private String suffix;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _interceptorName = interceptorName.concat(suffix);
        //
        _props.put("interceptorName", _interceptorName);
        _props.put("packageName", packageName);

        getLog().info("properties:");
        getLog().info("\t|--interceptorName:" + _interceptorName);
        getLog().info("\t|--packageName:" + packageName);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        __doWriteSingleFile(new File(_path, StringUtils.capitalize(_interceptorName.concat(".java"))), "interceptor-tmpl", _props);
    }
}
