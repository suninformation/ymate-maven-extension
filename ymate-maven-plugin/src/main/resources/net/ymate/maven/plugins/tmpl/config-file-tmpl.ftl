<#if isXml>
<?xml version="1.0" encoding="UTF-8"?>
<!-- 用XML格式书写与configuration.properties相同的配置内容 -->
<!-- XML根节点为properties, abc代表扩展属性key, xyz代表扩展属性值 -->
<properties abc="xyz">
    <!-- 分类节点为category, 默认分类名称为default, abc代表扩展属性key, xyz代表扩展属性值 -->
    <category name="default" abc="xyz">
        <!-- 属性标签为property, name代表属性名称, value代表属性值(也可以用property标签包裹), abc代表扩展属性key, xyz代表扩展属性值 -->
        <property name="company_name" abc="xyz" value="Apple Inc."/>
        <!-- 用属性标签表示一个数组或集合数据类型的方法, abc代表扩展属性key, xyz代表扩展属性值, 这一点与properties配置文件不同 -->
        <property name="products" abc="xyz">
            <!-- 集合元素必须用value标签包裹, 且value标签不要包括任何扩展属性 -->
            <value>iphone</value>
            <value>ipad</value>
            <value>imac</value>
            <value>itouch</value>
        </property>
        <!-- 用属性标签表示一个MAP数据类型的方法, abc代表扩展属性key, xyz代表扩展属性值, 扩展属性与item将被合并处理  -->
        <property name="product_spec" abc="xzy">
            <!-- MAP元素用item标签包裹, 且item标签必须包含name扩展属性(其它扩展属性将被忽略), 元素值由item标签包裹 -->
            <item name="color">red</item>
            <item name="weight">120g</item>
            <item name="size">small</item>
            <item name="age">2015</item>
        </property>
    </category>
</properties>
<#else>
#--------------------------------------------------------------------------
# \u914D\u7F6E\u6587\u4EF6\u5185\u5BB9\u683C\u5F0F: properties.<categoryName>.<propertyName>=[propertyValue]
#
# \u6CE8\u610F: attributes\u5C06\u4F5C\u4E3A\u5173\u952E\u5B57\u4F7F\u7528, \u7528\u4E8E\u8868\u793A\u5206\u7C7B, \u5C5E\u6027, \u96C6\u5408\u548CMAP\u7684\u5B50\u5C5E\u6027\u96C6\u5408
#--------------------------------------------------------------------------

# \u4E3E\u4F8B1: \u9ED8\u8BA4\u5206\u7C7B\u4E0B\u8868\u793A\u516C\u53F8\u540D\u79F0, \u9ED8\u8BA4\u5206\u7C7B\u540D\u79F0\u4E3Adefault
properties.default.company_name=Apple Inc.

# \u6839\u8282\u70B9\u5C5E\u6027\u7528attributes\u8868\u793A,, abc\u4EE3\u8868\u5C5E\u6027key, xyz\u4EE3\u8868\u5C5E\u6027\u503C
properties.attributes.abc=xzy

# \u6BCF\u4E2A\u5206\u7C7B\u90FD\u6709\u5C5E\u4E8E\u5176\u81EA\u8EAB\u7684\u5C5E\u6027\u5217\u8868, \u7528attributes\u8868\u793A, abc\u4EE3\u8868\u5C5E\u6027key, xyz\u4EE3\u8868\u5C5E\u6027\u503C
properties.default.attributes.abc=xyz
# \u6BCF\u4E2A\u5C5E\u6027\u90FD\u6709\u5C5E\u4E8E\u5176\u81EA\u8EAB\u7684\u5B50\u5C5E\u6027\u5217\u8868(\u6DF1\u5EA6\u4EC5\u4E3A\u4E00\u7EA7), \u7528attributes\u8868\u793A, abc\u4EE3\u8868\u5C5E\u6027key, xyz\u4EE3\u8868\u5C5E\u6027\u503C
properties.default.company_name.attributes.abc=xyz

#--------------------------------------------------------------------------
# \u6570\u7EC4\u548C\u96C6\u5408\u6570\u636E\u7C7B\u578B\u7684\u8868\u793A\u65B9\u6CD5: \u591A\u4E2A\u503C\u4E4B\u95F4\u7528'|'\u5206\u9694, \u5982: Value1|Value2|...|ValueN
#--------------------------------------------------------------------------
properties.default.products=iphone|ipad|imac|itouch

# \u6BCF\u4E2A\u96C6\u5408\u90FD\u6709\u5C5E\u4E8E\u5176\u81EA\u8EAB\u7684\u5C5E\u6027\u5217\u8868(\u6DF1\u5EA6\u4EC5\u4E3A\u4E00\u7EA7), \u7528attributes\u8868\u793A, abc\u4EE3\u8868\u5C5E\u6027key, xyz\u4EE3\u8868\u5C5E\u6027\u503C
properties.default.products.attributes.abc=xyz

#--------------------------------------------------------------------------
# MAP<K, V>\u6570\u636E\u7C7B\u578B\u7684\u8868\u793A\u65B9\u6CD5:
# \u5982:\u4EA7\u54C1\u89C4\u683C(product_spec)\u7684K\u5206\u522B\u662Fcolor|weight|size|age, \u5BF9\u5E94\u7684V\u5206\u522B\u662F\u70EDred|120g|small|2015
#--------------------------------------------------------------------------
properties.default.product_spec.color=red
properties.default.product_spec.weight=120g
properties.default.product_spec.size=small
properties.default.product_spec.age=2015

# \u6BCF\u4E2AMAP\u90FD\u6709\u5C5E\u4E8E\u5176\u81EA\u8EAB\u7684\u5C5E\u6027\u5217\u8868(\u6DF1\u5EA6\u4EC5\u4E3A\u4E00\u7EA7), \u7528attributes\u8868\u793A, abc\u4EE3\u8868\u5C5E\u6027key, xyz\u4EE3\u8868\u5C5E\u6027\u503C
# \u6CE8: MAP\u6570\u636E\u7C7B\u578B\u7684attributes\u548CMAP\u672C\u8EAB\u7684\u8868\u793A\u65B9\u6CD5\u8FBE\u5230\u7684\u6548\u679C\u662F\u4E00\u6837\u7684
properties.default.product_spec.attributes.abc=xyz
</#if>