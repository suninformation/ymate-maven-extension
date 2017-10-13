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
 * 验证器类生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午4:37
 * @version 1.0
 */
@Mojo(name = "validator")
public class ValidatorMojo extends AbstractTmplMojo {

    /**
     * 验证器名称
     */
    @Parameter(property = "name", required = true)
    private String validatorName;

    /**
     * 验证器存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.validation")
    private String packageName;

    /**
     * 验证器后缀, 默认为XxxxValidator
     */
    @Parameter(property = "suffix", defaultValue = "Validator")
    private String suffix;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _validatorName = validatorName.concat(suffix);
        //
        _props.put("validatorName", _validatorName);
        _props.put("packageName", packageName);
        _props.put("annotationName", validatorName);

        getLog().info("properties:");
        getLog().info("\t|--validatorName:" + _validatorName);
        getLog().info("\t|--packageName:" + packageName);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        //
        __doWriteSingleFile(new File(_path, "V".concat(StringUtils.capitalize(validatorName.concat(".java")))), "validator-annotation-tmpl", _props);
        __doWriteSingleFile(new File(_path, StringUtils.capitalize(_validatorName.concat(".java"))), "validator-tmpl", _props);
    }
}
