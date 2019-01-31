<#setting number_format="#">
package ${app.packageName}.dto;

<#if withDoc>import net.ymate.apidocs.annotation.*;</#if>
import net.ymate.framework.validation.*;
import net.ymate.platform.core.beans.annotation.*;
import net.ymate.platform.validation.annotation.*;
import net.ymate.platform.validation.validate.*;
import net.ymate.platform.webmvc.annotation.*;<#if upload>
import net.ymate.platform.webmvc.IUploadFileWrapper;</#if>

import java.io.Serializable;

/**
* ${api.name?cap_first}FormBean <#if api.description?? && (api.description?length > 0)>- ${api.description}</#if>
* <br>
* Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
*
* @author ${app.author?default("ymatescaffold")}
* @version ${app.version?default("1.0.0")}
*/
public class ${api.name?cap_first}UpdateFormBean implements Serializable {

    <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
    <#if (p.description??)>
    /**
    * ${p.description}
    */</#if>
    <#if p.validation??><#if p.required?? && p.required>
    @VRequired</#if><#if p.validation.regex?? && (p.validation.regex?length > 0)>
    @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
    @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
    @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
    @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
    @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
    @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>@VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>@VLength(max = ${p.validation.max})</#if><#if p.label?? && (p.label?length > 0)>
    @VField(label = "${p.label}")</#if></#if>
    @RequestParam<#if withDoc>
    @ApiParam(value = "<#if p.label?? && (p.label?length > 0)>${p.label}</#if>"<#if p.required?? && p.required>, required = true</#if>) </#if>
    private ${p.type?cap_first} ${p.name};

    </#if></#list></#if>

    <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
    public ${p.type?cap_first} get${p.name?cap_first}() {
        return ${p.name};
    }

    public void set${p.name?cap_first}(${p.type?cap_first} ${p.name}) {
        this.${p.name} = ${p.name};
    }

    </#if></#list></#if>
}