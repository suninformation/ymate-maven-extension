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

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.support.ConfigBuilder;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.persistence.jdbc.scaffold.EntityGenerator;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

/**
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午2:52
 * @version 1.0
 */
@Mojo(name = "entity")
public class EntityMojo extends AbstractTmplMojo {

    public void execute() throws MojoExecutionException, MojoFailureException {
        YMP _owner = null;
        try {
            File _propFile = new File(basedir, "/src/main/resources/ymp-conf.properties");
            if (!_propFile.exists()) {
                getLog().warn("Cannot found config file: " + _propFile);
            } else {
                Properties _props = new Properties();
                _props.load(new FileInputStream(_propFile));
                //
                _props.remove("ymp.i18n_event_handler_class");
                _props.remove("ymp.autoscan_packages");
                _props.remove("ymp.configs.persistence.jdbc.ds.default.adapter_class");
                _props.put("ymp.params.jdbc.output_path", new File(basedir, "/src/main/java").getPath());
                //
                _owner = new YMP(ConfigBuilder.create(_props).build()).init();
                //
                new EntityGenerator(_owner).createEntityClassFiles();
            }
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        } finally {
            if (_owner != null) {
                try {
                    _owner.destroy();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
