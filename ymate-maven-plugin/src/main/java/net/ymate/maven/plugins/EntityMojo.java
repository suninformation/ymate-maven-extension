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
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.persistence.jdbc.scaffold.EntityGenerator;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;

/**
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午2:52
 * @version 1.0
 */
@Mojo(name = "entity")
public class EntityMojo extends AbstractTmplMojo {

    @Parameter(property = "view")
    private boolean view;

    @Parameter(property = "markdown")
    private boolean markdown;

    @Parameter(property = "csv")
    private boolean csv;

    @Parameter(property = "onlyShow")
    private boolean onlyShow;

    public void execute() throws MojoExecutionException, MojoFailureException {
        YMP _owner = null;
        try {
            _owner = new YMP(__doCreateConfigBuilder().param("jdbc.output_path", new File(basedir, "/src/main/java").getPath()).build()).init();
            EntityGenerator _generator = new EntityGenerator(_owner);
            if (onlyShow) {
                _generator.onlyShow();
            }
            if (markdown) {
                _generator.markdown();
            } else if (csv) {
                _generator.csv();
            }
            _generator.createEntityClassFiles(view);
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
