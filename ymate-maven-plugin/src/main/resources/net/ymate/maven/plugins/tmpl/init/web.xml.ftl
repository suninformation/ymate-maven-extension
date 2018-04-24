<?xml version="1.0" encoding="UTF-8"?>
<web-app id="WebApp_ID" version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">

    <listener>
        <listener-class>net.ymate.platform.webmvc.support.WebAppEventListener</listener-class>
    </listener>

    <filter>
        <filter-name>DispatchFilter</filter-name>
        <filter-class>net.ymate.platform.webmvc.support.DispatchFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>DispatchFilter</filter-name>
        <url-pattern>/*</url-pattern>
        <dispatcher>REQUEST</dispatcher>
        <dispatcher>FORWARD</dispatcher>
    </filter-mapping>

    <!--
    <servlet>
        <servlet-name>DispatchServlet</servlet-name>
        <servlet-class>net.ymate.platform.webmvc.support.DispatchServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>DispatchServlet</servlet-name>
        <url-pattern>/service/*</url-pattern>
    </servlet-mapping>
    -->

    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
</web-app>