<?xml version="1.0" encoding="UTF-8"?>
<properties>
    <category name="default">
        <#list sqls?keys as key><property name="${key}">
            <value><![CDATA[${sqls["${key}"]}]]></value>
        </property>
        </#list>
    </category>
</properties>