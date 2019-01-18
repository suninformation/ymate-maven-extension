<%@ page contentType="text/html;charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.ymate.net/ymweb_core" prefix="ymweb" %>
<%@ taglib uri="http://www.ymate.net/ymweb_bs" prefix="bs" %>

<c:set var="_bootstrapTheme" value="false" scope="request"/>
<c:set var="_pageViewPort" value="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" scope="request"/>
<c:set var="_bodyClass" value="hold-transition skin-blue-light sidebar-mini" scope="request"/>
<c:set var="_pageAuthor" value="https://ymate.net/" scope="request"/>

<ymweb:ui src="webui/_adminLTE" cleanup="false">

    <ymweb:css href="@{page.path}assets/bootstrap/_components/datatables/dataTables.bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <ymweb:css href="@{page.path}assets/bootstrap/_components/select2/css/select2.min.css" rel="stylesheet" type="text/css"/>
    <ymweb:css href="@{page.path}assets/bootstrap/_components/icheck/all.css" rel="stylesheet" type="text/css"/>
    <ymweb:css href="@{page.path}assets/bootstrap/_components/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" type="text/css"/>
    <ymweb:css href="@{page.path}assets/bootstrap/_components/bootstrap-datepicker/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css"/>
    <ymweb:css href="@{page.path}assets/bootstrap/_components/jquery-confirm/jquery-confirm.min.css" rel="stylesheet" type="text/css"/>

    <ymweb:script src="@{page.path}assets/bootstrap/_components/datatables/jquery.dataTables.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/datatables/dataTables.bootstrap.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-paginator/bootstrap-paginator.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/select2/js/select2.full.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/icheck/icheck.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/moment/moment-with-locales.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-daterangepicker/daterangepicker.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-datepicker/js/bootstrap-datepicker.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-datepicker/locales/bootstrap-datepicker.zh-CN.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-timepicker/bootstrap-timepicker.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/bootstrap-growl/jquery.bootstrap-growl.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/jquery-confirm/jquery-confirm.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/_components/jquery-loading-overlay/loadingoverlay.min.js" type="text/javascript"/>
    <ymweb:script src="@{page.path}assets/bootstrap/scripts/ymate-webui.js" type="text/javascript"/>

    <ymweb:property name="page.styles">
        <style>
            body {
                font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", sans-serif;
            }
            .wrapper {
                overflow-y: hidden;
                z-index: 1041;
            }
            .form-control-static {
                background: #f6f6f6;
                padding: 10px;
            }
            .control-sidebar.control-sidebar-open,
            .control-sidebar.control-sidebar-open+.control-sidebar-bg {
                right: 0!important;
            }
            .control-sidebar.control-sidebar-open+.control-sidebar-bg {
                width:100%!important;
                border-left: 0;
                background: rgba(0, 0, 0, 0.3)
            }
            .control-sidebar-bg{
                transition:right 0s ease-in-out
            }
            .control-sidebar-width {
                width: 530px;
                right: -530px;
                min-height:100%;
            }
            @media only screen and (max-width: 769px) {
                .control-sidebar-width {
                    width: 100%;
                    right: -100%;
                }
            }
            @media only screen and (min-width: 770px) and (max-width: 1199px) {
                .control-sidebar-width {
                    width: 530px;
                    right: -530px;
                }
            }
            @media screen and (min-width:1200px) {
                .control-sidebar-width {
                    width: 740px;
                    right: -740px;
                }
            }
        </style>
        @{page.styles}
    </ymweb:property>

    <ymweb:property name="page.scripts">

        @{page.scripts}

        <script type="text/javascript">
            $(document).ready(function () {

                $('.navbar-custom-menu').html("<ul class=\"nav navbar-nav\">\n" +
                    "    <li class=\"user user-menu\">\n" +
                    "        <a href=\"#\">\n" +
                    "            <img src=\"@{page.path}assets/passport/images/avatar-none.jpg\" class=\"user-image\" alt=\"User Image\">\n" +
                    "            <span class=\"hidden-xs\">UserName</span>\n" +
                    "        </a>\n" +
                    "    </li>\n" +
                    "    <li><a href=\"@{page.path}logout\"><span class=\"glyphicon glyphicon-log-out\"></span></a></li>\n" +
                    "</ul>");

                $('.sidebar').navigation({
                    searchable: true,
                    items: [
                        {type: 'header', title: 'MAIN NAVIGATION'},
                        <#list _navMap?keys as key>
                        {
                            title: '${_navMap['${key}']}',
                            icon: '',
                            href: '@{page.path}${key}',
                            items: []
                        },
                        </#list>
                    ]
                });
            });
        </script>
    </ymweb:property>

    <ymweb:layout cleanup="false">
        <header class="main-header">
            <a href="#" class="logo">
                <span class="logo-mini"><b>A</b>LT</span>
                <span class="logo-lg"><b>Admin</b>LTE</span>
            </a>
            <nav class="navbar navbar-static-top">
                <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
                    <span class="sr-only">Toggle navigation</span>
                </a>
                <div class="navbar-custom-menu"></div>
            </nav>
        </header>
        <aside class="main-sidebar">
            <section class="sidebar"></section>
        </aside>
        <div class="content-wrapper">
            @{body}
        </div>
        @{body.after}
        <footer class="main-footer">
            <div class="pull-right hidden-xs">
                <b>Version</b> 2.4.0
            </div>
            <strong>Copyright &copy; 2014-2016 <a href="https://adminlte.io">Almsaeed Studio</a>.</strong> All rights reserved. Build by <a href="https://ymate.net">YMP</a>.
        </footer>
    </ymweb:layout>
</ymweb:ui>