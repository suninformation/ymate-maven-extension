<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.ymate.net/ymweb_core" prefix="ymweb" %>
<%@ taglib uri="http://www.ymate.net/ymweb_bs" prefix="bs" %>
<%@ taglib uri="http://www.ymate.net/ymweb_fn" prefix="func" %>

<ymweb:ui src="_base_crud_view">
    <ymweb:property name="title"><#if _description?? && (_description?length > 0)>${_description}<#else>${_name}</#if></ymweb:property>
    <#if (_pagePath?length > 0)><ymweb:property name="page.path">${_pagePath}</ymweb:property></#if>
    <ymweb:property name="page.activeItem">${_pagePath}${_mapping}</ymweb:property>
    <ymweb:property name="page.scripts">
        <script type="text/javascript">
            $(document).ready(function () {
                //
                var __columns = [
                    <#list _columns as p>
                    <#if (p.data != 'content')>
                    {
                        data: '${p.data}',
                        title: '${p.title}',
                        defaultContent: '',
                        <#if (p.type == 'integer' && p.data?starts_with('is'))>
                        render: function (data, type, row, meta) {
                            return __dict._logical[data] ? __dict._logical[data] : data;
                        },
                        <#elseif (p.type == 'integer' && p.data == 'type')>
                        render: function (data, type, row, meta) {
                            return __dict.type[data] ? __dict.type[data] : data;
                        },
                        <#elseif (p.type == 'integer' && p.data == 'status')>
                        render: function (data, type, row, meta) {
                            return __dict.status[data] ? __dict.status[data] : data;
                        },
                        <#elseif (p.data == 'createTime' || p.data == 'lastModifyTime')>
                        width: '150px',
                        render: function (data, type, row, meta) {
                            return data ? moment(data).format('YYYY-MM-DD HH:mm:ss') : '';
                        },
                        </#if>
                    },
                    </#if>
                    </#list>
                ];
                //
                var __dict = {
                    _logical: {
                        '0': '否',
                        '1': '是'
                    },
                    status: {
                        '0': '正常',
                        '1': '禁用'
                    },
                    type: {
                        '0': '默认'
                    }
                };
                //
                var __sidebar = $('#_control-sidebar-self').on('click', function () {
                    __tabSwitcher.reset();
                });
                //
                var __searchForm = $('#_formSearch').formWrapper({
                    beforeSubmit: function (data) {
                    },
                    afterSubmit: function (textStatus, data) {
                    },
                    onReset: function (formEl, formSubmitter) {
                        $('.select2', formEl).trigger('change');
                    },
                    callback: function (result) {
                        __tables.refresh(result);
                    }
                });
                var __tabSwitcher = $('#_tabs').tabSwitcher({
                    tabs: [
                        {
                            id: '_tabCreate',
                            form: {
                                beforeSubmit: function (data) {
                                },
                                afterSubmit: function (textStatus, data) {
                                },
                                onReset: function (formEl, formSubmitter) {
                                    $('.select2', formEl).trigger('change');
                                },
                                callback: function (result) {
                                    if (result.ret === 0) {
                                        __doChangePageQuery();
                                        __sidebarTrigger();
                                        __notifyShow('添加新记录成功！', 'success');
                                    }
                                }
                            },
                            onShow: function (tabContent, formWrapper) {
                            }
                        }, {
                            id: '_tabUpdate',
                            form: {
                                beforeSubmit: function (data) {
                                },
                                afterSubmit: function (textStatus, data) {
                                },
                                onReset: function (formEl, formSubmitter) {
                                    $('.select2', formEl).trigger('change');
                                },
                                callback: function (result) {
                                    if (result.ret === 0) {
                                        __doChangePageQuery(__tables.getCurrentPageNumber());
                                        __sidebarTrigger();
                                        __notifyShow('更新记录成功！', 'success');
                                    }
                                }
                            },
                            onShow: function (tabContent, formWrapper) {
                            }
                        }, {
                            id: '_tabDetail',
                            onShow: function (tabContent, formWrapper) {
                            }
                        }
                    ]
                });

                var __tables = $('#_tableResult').tables({
                    tableOps: {
                        columns: __columns
                    },
                    callback: {
                        loaded: function (settings) {
                        },
                        operations: function (data, type, row, meta) {
                            return [
                                {name: "修改", fn: "Edit", param: row.id, type: "default", icon: "edit"},
                                {name: "详情", fn: "Detail", param: row.id, type: "default", icon: "file-text-o"},
                                <#if (_columnKeys?seq_contains('status'))>
                                {name: row.status === 1 ? "启用" : "禁用", fn: "Status", param: row.id},
                                {name: "-"},
                                </#if>
                                {name: "删除", fn: "Remove", param: row.id, icon: "trash"}
                            ];
                        },
                        beforeData: function (data) {
                        },
                        afterData: function (result) {
                            $('#_paginator').paginator({
                                paginated: result.data.paginated,
                                totalPages: result.data.pageCount,
                                recordsTotal: result.data.paginated ? result.data.recordCount : result.data.resultData.length,
                                currentPage: result.data.pageNumber,
                                change: __doChangePageQuery
                            });
                        }
                    }
                });

                function __sidebarTrigger() {
                    __sidebar.trigger('click');
                }

                function __doChangePageQuery(page) {
                    var _data = __searchForm.getFormSubmitter().getFormData();
                    if (page) {
                        _data.page = page;
                    }
                    $.requestSender({
                        url: __searchForm.getForm().attr("action"),
                        type: __searchForm.getForm().attr("method"),
                        timeout: 0,
                        data: _data,
                        success: function (data, textStatus, jqXHR) {
                            __tables.refresh(data);
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            console.log(errorThrown);
                        }
                    });
                }

                function __doRemove(id) {
                    var _len = id ? (id instanceof Array ?  id.length : 1) : 0;
                    if (_len > 0) {
                        __confirmShow({
                            content: '确认要删除选中的 ' + _len + " 条记录吗？",
                            ok: function () {
                                $.requestSender({
                                    url: '${_pagePath}${_mapping}/remove',
                                    type: 'POST',
                                    timeout: 0,
                                    data: {
                                        id: id
                                    },
                                    success: function (data, textStatus, jqXHR) {
                                        __doChangePageQuery(__tables.getCurrentPageNumber());
                                    },
                                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                                        console.log(errorThrown);
                                    }
                                });
                            }
                        });
                    } else {
                        __notifyShow('请选择至少一条要删除的记录！', 'warning');
                    }
                }

                function __doDetail(param, callback) {
                    __overlayShow();
                    $.requestSender({
                        url: '${_pagePath}${_mapping}/detail',
                        type: 'get',
                        timeout: 0,
                        data: {
                            id: param
                        },
                        success: function (data, textStatus, jqXHR) {
                            if (data && data.ret === 0) {
                                callback(data);
                                __sidebarTrigger();
                            } else {
                                __notifyShow(data.msg, 'error')
                            }
                            __overlayShow(true);
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            __overlayShow(true);
                            __notifyShow(errorThrown, 'error')
                        }
                    });
                }

                window.__onCreate = function() {
                    __tabSwitcher.show('_tabCreate');
                    __sidebarTrigger();
                };

                window.__onEdit = function (param) {
                    __doDetail(param, function (result) {
                        __tabSwitcher.show('_tabUpdate');
                        __tabSwitcher.getFormWrapper('_tabUpdate').setFormData(result.data);
                    });
                };

                window.__onDetail = function(param) {
                    __doDetail(param, function (result) {
                        var _tmpl = '{% for (var i = 0; i < o.items.length; i++) { %}<div class=" form-group"><label class="control-label">{%=o.items[i].title%}</label><{% if (o.items[i].tag) { %}{%=o.items[i].tag%}{% } else { %}p{% }%} class=" form-control-static">{%=o.items[i].content%}</{% if (o.items[i].tag) { %}{%=o.items[i].tag%}{% } else { %}p{% }%}></div>{% } %}';
                        $('#_tabDetail .box-body').html(tmpl(_tmpl, {
                            items: [
                            <#list _columns as p>
                                <#if (p.data == 'createTime' || p.data == 'lastModifyTime')>
                                { title: '${p.title}', content: result.data.${p.data} ? moment(result.data.${p.data}).format('YYYY-MM-DD HH:mm:ss') : ''},
                                <#elseif (p.type == 'integer' && p.data?starts_with('is'))>
                                { title: '${p.title}', content: __dict._logical[result.data.${p.data}] ? __dict._logical[result.data.${p.data}] : result.data.${p.data}},
                                <#elseif (p.type == 'integer' && p.data == 'type')>
                                { title: '${p.title}', content: __dict.type[result.data.${p.data}] ? __dict.type[result.data.${p.data}] : result.data.${p.data}},
                                <#elseif (p.type == 'integer' && p.data == 'status')>
                                { title: '${p.title}', content: __dict.status[result.data.${p.data}] ? __dict.status[result.data.${p.data}] : result.data.${p.data}},
                                <#else>
                                { title: '${p.title}', content: result.data.${p.data}},
                                </#if>
                            </#list>
                            ]
                        }));
                        __tabSwitcher.show('_tabDetail');
                    });
                };

                window.__onRemoveAll = function() {
                    __doRemove(__tables.selectedIds());
                };

                window.__onRemove = function(param) {
                    __doRemove(param);
                };

                <#if (_columnKeys?seq_contains('status'))>
                window.__onStatus = function(param) {
                    if (param) {
                        var _item = __tables.findItem(param);
                        if (_item) {
                            __confirmShow({
                                ok: function () {
                                    $.requestSender({
                                        url: '${_pagePath}${_mapping}/status/' + (_item.status === 1 ? 'enable' : 'disable'),
                                        type: 'POST',
                                        timeout: 0,
                                        data: {
                                            id: param
                                        },
                                        success: function (data, textStatus, jqXHR) {
                                            __doChangePageQuery(__tables.getCurrentPageNumber());
                                        },
                                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                                            console.log(errorThrown);
                                        }
                                    });
                                }
                            });
                        } else {
                            __notifyShow('请选择一条要操作的记录！', 'warning');
                        }
                    }
                };
                </#if>

                $('[data-toggle="tooltip"]').tooltip();
                $('.select2').select2();
                $('.dateRangePicker').dateRangeWrapper();
                $('.datePicker').datepicker({
                    format: "yyyy-mm-dd",
                    language: "zh-CN"
                });

                // 页面加载完成后自动查询数据
                __searchForm.submit();
            });
        </script>
    </ymweb:property>
    <ymweb:layout>
        <section class="content-header">
            <h1>${_name}<small>${_description}</small></h1>
        </section>
        <section class="content">
            <bs:form _id="_formSearch" action="${_pagePath}${_mapping}/query" method="GET">
                <div class="box">
                    <div class="box-header with-border">
                        <h3 class="box-title">查询条件</h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" title="Collapse"><i class="fa fa-minus"></i></button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="messageShow" data-message-show=""></div>
                        <bs:row>
                        <#list _columns as p>
                            <#if (p.filter)>
                            <bs:col md="3" lg="2">
                            <#if (p.type == 'integer' && (p.data == 'status' || p.data == 'type' || p.data?starts_with('is')))>
                                <bs:form-group>
                                    <bs:form-control _class="select2" _style="width: 100%;" type="select" label="${p.title}" name="${p.data}" helpBlockClass="with-errors" data-error="请正确输入${p.title}">
                                        <option value="">全部</option>
                                        <#if (p.data == 'status')>
                                        <option value="0">正常</option>
                                        <option value="1">禁用</option>
                                        <#elseif (p.data == 'type')>
                                        <option value="0">默认</option>
                                        <#elseif (p.data?starts_with('is'))>
                                        <option value="0">否</option>
                                        <option value="1">是</option>
                                        </#if>
                                    </bs:form-control>
                                </bs:form-group>
                            <#else>
                                <bs:form-group>
                                    <bs:form-control <#if (p.region || p.data == 'createTime' || p.data == 'lastModifyTime')>_class="dateRangePicker"</#if> name="${p.data}" type="text" label="${p.title}" placeholder="请输入${p.title}" helpBlockClass="with-errors" maxlength="32" data-error="请正确输入${p.title}"/>
                                </bs:form-group>
                            </#if>
                            </bs:col>
                            </#if>
                        </#list>
                        </bs:row>
                    </div>
                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary" data-loading-text="正在处理..."><i class="fa fa-search"></i> 搜索</button>
                        <button type="reset" class="btn btn-default">重置</button>
                    </div>
                </div>
            </bs:form>
            <div class="box">
                <div class="box-header">
                    <h3 class="box-title">查询结果</h3>
                    <div class="pull-right box-tools">
                        <div class="btn-group btn-group-sm">
                            <button class="btn btn-default" type="button" data-operations="operations" data-operation-fn="Create"><i class="fa fa-plus"></i></button>
                            <button class="btn btn-default" type="button" data-operations="operations" data-operation-fn="RemoveAll"><i class="fa fa-trash-o"></i></button>
                        </div>
                    </div>
                </div>
                <div class="box-body">
                    <div class="table-responsive"><table id="_tableResult" class="table table-bordered table-striped table-hover"></table></div>
                </div>
                <div class="box-footer">
                    <div id="_paginator" class="row"><div class="paginationInfo col-md-6"></div><div class="col-md-6"><ul style="margin-bottom: 0; margin-top: 0;"></ul></div></div>
                </div>
            </div>
        </section>
    </ymweb:layout>
    <ymweb:property name="body.after">
        <aside class="control-sidebar control-sidebar-light control-sidebar-width">
            <div class="box-header">
                <h3 class="box-title"></h3>
                <div class="pull-right box-tools">
                    <div class="btn-group btn-group-sm">
                        <button class="btn btn-default" data-toggle="control-sidebar" id="_control-sidebar-self"><i class="fa fa-times"></i></button>
                    </div>
                </div>
            </div>
            <div class="box-body">
                <ul id="_tabs" class=" nav nav-tabs" style="display: none;">
                    <li><a href="#" data-toggle="tab" data-target="#_tabCreate"></a></li>
                    <li><a href="#" data-toggle="tab" data-target="#_tabUpdate"></a></li>
                    <li><a href="#" data-toggle="tab" data-target="#_tabDetail"></a></li>
                </ul>
                <div class="tab-content">
                    <div id="_tabCreate" class="tab-pane">
                        <form action="${_pagePath}${_mapping}/create" method="POST">
                            <div class="box box-widget">
                                <div class="box-header with-border">
                                    <h3 class="box-title">添加<#if _description?? && (_description?length > 0)>${_description}<#else>${_name}</#if></h3>
                                </div>
                                <div class="box-body">
                                    <div class="messageShow" data-message-show=""></div>
                                    <#list _columns as p>
                                        <#if (p.data != 'id' && p.data != 'createTime' && p.data != 'lastModifyTime')>
                                        <#if (p.type == 'integer' && p.data == 'gender')>
                                            <bs:form-group>
                                                <bs:form-control inline="true" type="radio" label="${p.title}"  helpBlockClass="with-errors">
                                                    <bs:radio name="${p.data}" value="1" <#if (p.required)>required="required"</#if>>男</bs:radio>
                                                    <bs:radio name="${p.data}" value="2">女</bs:radio>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif (p.type == 'integer' && p.data?starts_with('is'))>
                                            <bs:form-group>
                                                <bs:form-control inline="true" type="radio" label="${p.title}"  helpBlockClass="with-errors">
                                                    <bs:radio name="${p.data}" value="0" <#if (p.required)>required="required"</#if>>否</bs:radio>
                                                    <bs:radio name="${p.data}" value="1">是</bs:radio>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif ((p.type == 'integer' && (p.data == 'status' || p.data == 'type')))>
                                            <bs:form-group>
                                                <bs:form-control _class="select2" _style="width: 100%;" type="select" label="${p.title}" name="${p.data}" <#if (p.required)>required="required"</#if> helpBlockClass="with-errors" data-error="请正确输入${p.title}">
                                                    <option value="">全部</option>
                                                    <#if (p.data == 'status')>
                                                        <option value="0">正常</option>
                                                        <option value="1">禁用</option>
                                                    <#elseif (p.data == 'type')>
                                                        <option value="0">默认</option>
                                                    </#if>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif (p.data == 'birthday')>
                                            <bs:form-group>
                                                <bs:form-control name="${p.data}" type="text" _class="datePicker"
                                                                 label="${p.title}"
                                                                 placeholder="请输入${p.title}" <#if (p.required)>required="required"</#if>
                                                                 helpBlockClass="with-errors" maxlength="10"
                                                                 data-error="请正确输入${p.title}">
                                                    <#if (_columnKeys?seq_contains('is_lunar_birth'))>
                                                    <bs:form-control type="checkbox">
                                                        <bs:checkbox name="is_lunar_birth" value="1">是否农历生日</bs:checkbox>
                                                    </bs:form-control>
                                                    </#if>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#else>
                                            <bs:form-group>
                                                <bs:form-control type="text<#if (p.data == 'content' || p.data == 'description' || p.data == 'remark')>area</#if>" label="${p.title}" name="${p.data}" placeholder="请输入${p.title}" <#if (p.required)>required="required"</#if> maxlength="32" helpBlockClass="with-errors" data-error="请正确输入${p.title}"/>
                                            </bs:form-group>
                                        </#if>
                                        </#if>
                                    </#list>
                                </div>
                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary" data-loading-text="正在处理...">确认提交</button>
                                    <button type="reset" class="btn btn-default">重置</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div id="_tabUpdate" class="tab-pane">
                        <form action="${_pagePath}${_mapping}/update" method="POST">
                            <div class="box box-widget">
                                <div class="box-header with-border">
                                    <h3 class="box-title">修改<#if _description?? && (_description?length > 0)>${_description}<#else>${_name}</#if></h3>
                                </div>
                                <div class="box-body">
                                    <div class="messageShow" data-message-show=""></div>
                                    <#list _columns as p>
                                        <#if (p.data == 'id')>
                                            <input name="id" type="hidden" value="">
                                        <#elseif (p.type == 'integer' && p.data == 'gender')>
                                            <bs:form-group>
                                                <bs:form-control inline="true" type="radio" label="${p.title}"  helpBlockClass="with-errors">
                                                    <bs:radio name="${p.data}" value="1" <#if (p.required)>required="required"</#if>>男</bs:radio>
                                                    <bs:radio name="${p.data}" value="2">女</bs:radio>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif (p.type == 'integer' && p.data?starts_with('is'))>
                                            <bs:form-group>
                                                <bs:form-control inline="true" type="radio" label="${p.title}"  helpBlockClass="with-errors">
                                                    <bs:radio name="${p.data}" value="0" <#if (p.required)>required="required"</#if>>否</bs:radio>
                                                    <bs:radio name="${p.data}" value="1">是</bs:radio>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif ((p.type == 'integer' && (p.data == 'status' || p.data == 'type')))>
                                            <bs:form-group>
                                                <bs:form-control _class="select2" _style="width: 100%;" type="select" label="${p.title}" name="${p.data}" <#if (p.required)>required="required"</#if> helpBlockClass="with-errors" data-error="请正确输入${p.title}">
                                                    <option value="">全部</option>
                                                    <#if (p.data == 'status')>
                                                        <option value="0">正常</option>
                                                        <option value="1">禁用</option>
                                                    <#elseif (p.data == 'type')>
                                                        <option value="0">默认</option>
                                                    </#if>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif (p.data == 'birthday')>
                                            <bs:form-group>
                                                <bs:form-control name="${p.data}" type="text" _class="datePicker"
                                                                 label="${p.title}"
                                                                 placeholder="请输入${p.title}" <#if (p.required)>required="required"</#if>
                                                                 helpBlockClass="with-errors" maxlength="10"
                                                                 data-error="请正确输入${p.title}">
                                                    <bs:form-control type="checkbox">
                                                        <bs:checkbox name="is_lunar_birth" value="1">是否农历生日</bs:checkbox>
                                                    </bs:form-control>
                                                </bs:form-control>
                                            </bs:form-group>
                                        <#elseif (p.data != 'createTime' && p.data != 'lastModifyTime')>
                                            <bs:form-group>
                                                <bs:form-control type="text<#if (p.data == 'content' || p.data == 'description' || p.data == 'remark')>area</#if>" label="${p.title}" name="${p.data}" placeholder="请输入${p.title}" <#if (p.required)>required="required"</#if> maxlength="32" helpBlockClass="with-errors" data-error="请正确输入${p.title}"/>
                                            </bs:form-group>
                                        </#if>
                                    </#list>
                                </div>
                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary" data-loading-text="正在处理...">确认提交</button>
                                    <button type="reset" class="btn btn-default">重置</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div id="_tabDetail" class="tab-pane">
                        <div class="box box-widget">
                            <div class="box-header with-border">
                                <h3 class="box-title"><#if _description?? && (_description?length > 0)>${_description}<#else>${_name}</#if>详细信息</h3>
                            </div>
                            <div class="box-body"></div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>
        <div class="control-sidebar-bg control-sidebar-width"></div>
    </ymweb:property>
</ymweb:ui>