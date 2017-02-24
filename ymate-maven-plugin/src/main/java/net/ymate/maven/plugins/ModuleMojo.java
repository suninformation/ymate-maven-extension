/*
 * Copyright 2007-2017 the original author or authors.
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
 * 模块代码生成器
 *
 * @author 刘镇 (suninformation@163.com) on 17/2/21 下午4:27
 * @version 1.0
 */
@Mojo(name = "module")
public class ModuleMojo extends AbstractTmplMojo {

    /**
     * 模块名称
     */
    @Parameter(property = "name", required = true)
    private String moduleName;

    /**
     * 模块包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.module")
    private String packageName;

    @Parameter(property = "artifactId", defaultValue = "${project.artifactId}")
    private String moduleArtifactId;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        moduleName = StringUtils.capitalize(moduleName);
        _props.put("packageName", packageName);
        _props.put("moduleName", moduleName);
        _props.put("moduleArtifactId", moduleArtifactId);
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        //
        __doOutputModuleFile(new File(_path, "I".concat(moduleName).concat(".java")), "module/module-interface-tmpl", _props);
        __doOutputModuleFile(new File(_path, moduleName.concat(".java")), "module/module-class-tmpl", _props);
        __doOutputModuleFile(new File(_path, "I".concat(moduleName.concat("ModuleCfg.java"))), "module/module-cfg-tmpl", _props);
        __doOutputModuleFile(new File(_path, "impl/DefaultModuleCfg.java"), "module/module-cfgimpl-tmpl", _props);
    }

    private void __doOutputModuleFile(File targetFile, String tmplFile, Map<String, Object> props) {
        if (!targetFile.exists() || (targetFile.exists() && overwrite)) {
            try {
                if (targetFile.getParentFile().exists() || targetFile.getParentFile().mkdirs()) {
                    __doWriterTargetFile(targetFile.getParentFile().getPath(), targetFile.getName(), tmplFile, props);
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            getLog().warn("Skip existing file " + targetFile);
        }
    }
}
