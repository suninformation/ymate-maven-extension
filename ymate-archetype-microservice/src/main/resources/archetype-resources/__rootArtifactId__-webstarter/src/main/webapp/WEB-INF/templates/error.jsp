#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.ymate.net/ymweb_core" prefix="ymweb" %>
<%@ taglib uri="http://www.ymate.net/ymweb_fn" prefix="func" %>

<html lang="zh" class="md">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <base href="<ymweb:url/>"/>
    <title><c:choose><c:when test="${symbol_dollar}{not empty requestScope.ret and requestScope.ret != 0}">${symbol_dollar}{func:i18nMessage('messages', 'error.page.title_wrong', '出错了')}</c:when><c:otherwise>${symbol_dollar}{func:i18nMessage('messages', 'error.page.title_warn', '提示')}</c:otherwise></c:choose></title>
    <link href="assets/error/css/styles.css" rel="stylesheet"/>
</head>

<body>
<div class="content">
    <div class="icon <c:choose><c:when test="${symbol_dollar}{not empty requestScope.ret && requestScope.ret == 0}">icon-warning</c:when><c:otherwise>icon-wrong</c:otherwise></c:choose>"></div>
    <h1><c:choose><c:when test="${symbol_dollar}{not empty param.status}"><ymweb:httpStatusI18n code="${symbol_dollar}{param.status}"/> (${symbol_dollar}{param.status})
    </c:when><c:otherwise>${symbol_dollar}{requestScope.msg}</c:otherwise></c:choose><c:if test="${symbol_dollar}{not empty requestScope.ret and requestScope.ret != 0}"> (${symbol_dollar}{func:i18nMessage('messages', 'error.page.label_code', '代码：')} ${symbol_dollar}{requestScope.ret})</c:if></h1>
    <c:if test="${symbol_dollar}{not empty requestScope.subtitle}">
    <p id="subtitle">
        <span>${symbol_dollar}{requestScope.subtitle}</span>
        <c:if test="${symbol_dollar}{not empty requestScope.moreUrl}"><a class="learn-more-button" href="${symbol_dollar}{requestScope.moreUrl}">${symbol_dollar}{func:i18nMessage('messages', 'error.page.btn_more_details', '了解详情')}</a></c:if>
    </p>
    </c:if>
    <c:if test="${symbol_dollar}{not empty requestScope.data}">
    <div>
        <div class="detail">
            <em>${symbol_dollar}{func:i18nMessage('messages', 'error.page.label_details', '详细信息如下：')}</em>
            <ul><c:forEach var="_item" items="${symbol_dollar}{requestScope.data}">
                <li>${symbol_dollar}{_item.value}</li>
            </c:forEach></ul>
        </div>
        <div class="clearer"></div>
    </div>
    </c:if>
</div>
</body>
</html>