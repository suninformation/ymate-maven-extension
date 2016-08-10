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

import net.ymate.platform.core.util.RuntimeUtils;
import org.apache.commons.io.FileUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author 刘镇 (suninformation@163.com) on 15/10/26 下午2:56
 * @version 1.0
 */
@Mojo(name = "tomcat")
public class TomcatMojo extends AbstractTmplMojo {

    /**
     * 需要创建的目录列表
     */
    private static String[] __NEED_MK_DIRS = new String[]{
            "bin",
            "conf",
            "logs",
            "temp",
            "webapps",
            "webapps/ROOT",
            "work"
    };

    /**
     * 需要复制的配置文件列表
     */
    private static String[] __NEED_COPY_FILES = new String[]{
            "conf/catalina.policy",
            "conf/catalina.properties",
            "conf/logging.properties",
            "conf/context.xml",
            "conf/tomcat-users.xml",
            "conf/web.xml"
    };

    /**
     * Tomcat8需要复制的文件列表
     */
    private static String[] __V8_COPY_FILES = new String[]{
            "conf/jaspic-providers.xml",
            "conf/jaspic-providers.xsd",
            "conf/tomcat-users.xsd"
    };

    @Parameter(property = "serviceName", required = true)
    private String serviceName;

    @Parameter(property = "catalinaHome", required = true, defaultValue = "${env.CATALINA_HOME}")
    private String catalinaHome;

    @Parameter(property = "catalinaBase", defaultValue = "${basedir}")
    private String catalinaBase;

    @Parameter(property = "hostName", defaultValue = "localhost")
    private String hostName;

    @Parameter(property = "hostAlias")
    private String hostAlias;

    @Parameter(property = "tomcatVersion", defaultValue = "7")
    private int tomcatVersion;

    @Parameter(property = "serverPort", defaultValue = "8005")
    private int serverPort;

    @Parameter(property = "connectorPort", defaultValue = "8080")
    private int connectorPort;

    @Parameter(property = "redirectPort", defaultValue = "8443")
    private int redirectPort;

    @Parameter(property = "ajpHost", defaultValue = "localhost")
    private String ajpHost;

    @Parameter(property = "ajpPort", defaultValue = "8009")
    private int ajpPort;

    private void __doCheckFiles() throws Exception {
        File _file = new File(catalinaHome);
        if (!_file.exists() || !_file.isDirectory()) {
            throw new IllegalArgumentException("catalinaHome Illegal");
        }
        _file = new File(catalinaBase);
        if (!_file.exists() || !_file.isDirectory()) {
            throw new IllegalArgumentException("catalinaBase Illegal");
        }
        for (String _fileName : __NEED_COPY_FILES) {
            File _tmpFile = new File(this.catalinaHome, _fileName);
            if (!_tmpFile.exists() || !_tmpFile.isFile()) {
                throw new FileNotFoundException(_fileName);
            }
        }
    }

    private void __doMakeDirs(File parent) throws Exception {
        if (parent.mkdir()) {
            for (String _dirName : __NEED_MK_DIRS) {
                new File(parent, _dirName).mkdir();
            }
        }
    }

    private void __doCopyConfFiles(File parent) throws Exception {
        for (String _fileName : __NEED_COPY_FILES) {
            FileUtils.copyFile(new File(catalinaHome, _fileName), new File(parent, _fileName));
        }
        if (tomcatVersion == 8)
            for (String _fileName : __V8_COPY_FILES) {
                FileUtils.copyFile(new File(catalinaHome, _fileName), new File(parent, _fileName));
            }
    }

    public void execute() throws MojoExecutionException, MojoFailureException {
        try {
            __doCheckFiles();
            //
            File _parent = new File(catalinaBase, serviceName);
            __doMakeDirs(_parent);
            //
            Map<String, Object> _prop = new HashMap<String, Object>();
            _prop.put("catalina_home", catalinaHome);
            _prop.put("catalina_base", _parent.getPath());
            if (tomcatVersion <= 0) {
                tomcatVersion = 7;
            }
            //
            __doCopyConfFiles(_parent);
            //
            _prop.put("tomcat_version", Integer.toString(tomcatVersion));
            _prop.put("host_name", hostName);
            _prop.put("host_alias", hostAlias);
            _prop.put("website_root_path", new File(_parent, "webapps/ROOT").getPath());
            _prop.put("service_name", serviceName);
            _prop.put("server_port", Integer.toString(serverPort));
            _prop.put("connector_port", Integer.toString(connectorPort));
            _prop.put("redirect_port", Integer.toString(redirectPort));
            _prop.put("ajp_host", ajpHost);
            _prop.put("ajp_port", Integer.toString(ajpPort));
            //
            getLog().info("Tomcat Service:" + serviceName);
            getLog().info("\t|--CatalinaHome:" + catalinaHome);
            getLog().info("\t|--CatalinaBase:" + catalinaBase);
            getLog().info("\t|--HostName:" + hostName);
            getLog().info("\t|--HostAlias:" + hostAlias);
            getLog().info("\t|--TomcatVersion:" + tomcatVersion);
            getLog().info("\t|--ServerPort:" + serverPort);
            getLog().info("\t|--ConnectorPort:" + connectorPort);
            getLog().info("\t|--RedirectPort:" + redirectPort);
            getLog().info("\t|--AjpHost:" + ajpHost);
            getLog().info("\t|--AjpPort:" + ajpPort);
            //
            __doWriterTargetFile(_parent.getPath(), "conf/server.xml", "/tomcat/v" + tomcatVersion + "/server-xml.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "vhost.conf", "/tomcat/vhost-conf.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/install.bat", "/tomcat/install-cmd.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/manager.bat", "/tomcat/manager-cmd.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/shutdown.bat", "/tomcat/shutdown-cmd.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/startup.bat", "/tomcat/startup-cmd.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/uninstall.bat", "/tomcat/uninstall-cmd.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "bin/manager.sh", "/tomcat/manager-sh.ftl", _prop);
            __doWriterTargetFile(_parent.getPath(), "webapps/ROOT/index.jsp", "/tomcat/index-jsp.ftl", _prop);
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        }
    }
}
