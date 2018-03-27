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

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.lang.BlurObject;
import net.ymate.platform.core.support.ConsoleTableBuilder;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.persistence.IResultSet;
import net.ymate.platform.persistence.Page;
import net.ymate.platform.persistence.jdbc.ISession;
import net.ymate.platform.persistence.jdbc.ISessionExecutor;
import net.ymate.platform.persistence.jdbc.JDBC;
import net.ymate.platform.persistence.jdbc.base.IResultSetHandler;
import net.ymate.platform.persistence.jdbc.query.SQL;
import net.ymate.platform.persistence.jdbc.support.ResultSetHelper;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

/**
 * @author 刘镇 (suninformation@163.com) on 2018/3/27 下午6:25
 * @version 1.0
 */
@Mojo(name = "dbquery")
public class DBQueryMojo extends AbstractTmplMojo {

    @Parameter(property = "sql", required = true)
    private String sql;

    @Parameter(property = "format", defaultValue = "table")
    private String format;

    @Parameter(property = "page", defaultValue = "0")
    private int page;

    @Parameter(property = "pageSize", defaultValue = "0")
    private int pageSize;

    public void execute() throws MojoExecutionException, MojoFailureException {
        if (!StringUtils.containsIgnoreCase(sql, "select")) {
            throw new MojoExecutionException("The execution of the SQL statement must contain the SELECT keyword.");
        } else {
            YMP _owner = null;
            try {
                sql = StringUtils.replaceChars(sql, "\r\n\t", " ");
                getLog().info("SQL: " + sql);
                //
                _owner = new YMP(__doCreateConfigBuilder().build()).init();
                final String _sql = sql;
                final Page _page;
                if (page > 0) {
                    _page = Page.create(page).pageSize(pageSize);
                } else {
                    _page = null;
                }
                IResultSet<Object[]> _results = JDBC.get(_owner).openSession(new ISessionExecutor<IResultSet<Object[]>>() {
                    public IResultSet<Object[]> execute(ISession session) throws Exception {
                        return session.find(SQL.create(_sql), IResultSetHandler.ARRAY, _page);
                    }
                });
                getLog().info("------------------------------------------------------------------------");
                if (_page != null) {
                    getLog().info("Record count: " + _results.getRecordCount());
                    getLog().info("Current page: " + _results.getPageNumber() + "/" + _results.getPageCount() + " - " + _results.getPageSize());
                } else {
                    getLog().info("Record count: " + _results.getResultData().size());
                }
                getLog().info("------------------------------------------------------------------------");
                if (_results.isResultsAvailable()) {
                    ResultSetHelper _helper = ResultSetHelper.bind(_results);
                    //
                    final ConsoleTableBuilder _console = ConsoleTableBuilder.create(_helper.getColumnNames().length);
                    if (StringUtils.equalsIgnoreCase(format, "markdown")) {
                        _console.markdown();
                    } else if (StringUtils.equalsIgnoreCase(format, "csv")) {
                        _console.csv();
                    }
                    System.out.println();
                    //
                    ConsoleTableBuilder.Row _header = _console.addRow();
                    for (String _cName : _helper.getColumnNames()) {
                        _header.addColumn(StringUtils.upperCase(_cName));
                    }
                    _helper.forEach(new ResultSetHelper.ItemHandler() {
                        public boolean handle(ResultSetHelper.ItemWrapper wrapper, int row) throws Exception {
                            ConsoleTableBuilder.Row _line = _console.addRow();
                            for (String _cName : wrapper.getColumnNames()) {
                                String _value = BlurObject.bind(wrapper.getObject(_cName)).toStringValue();
                                _value = StringUtils.replace(_value, "\r", "[\\r]");
                                _value = StringUtils.replace(_value, "\n", "[\\n]");
                                _value = StringUtils.replace(_value, "\t", "[\\t]");
                                _line.addColumn(_value);
                            }
                            return true;
                        }
                    });
                    System.out.println(_console.toString());
                } else {
                    System.out.println("\n// Empty... :p\n");
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
}
