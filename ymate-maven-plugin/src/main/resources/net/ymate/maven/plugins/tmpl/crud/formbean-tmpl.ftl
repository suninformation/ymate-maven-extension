<#setting number_format="#">
package ${app.packageName}.dto;

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
public class ${api.name?cap_first}FormBean implements Serializable {

    <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
    <#if (p.description??)>
    /**
    * ${p.description}
    */</#if>
    <#if p.filter?? && p.filter.enabled><#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>
    @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
    @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
    @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
    @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
    @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
    @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>@VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>@VLength(max = ${p.validation.max})</#if><#if p.label?? && (p.label?length > 0)>
    @VField(label = "${p.label}<#if p.filter.region>范围最小值</#if>")</#if></#if>
    @RequestParam
    private ${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if>;<#if p.filter.region>
    <#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>

    @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
    @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
    @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
    @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
    @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
    @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>@VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>@VLength(max = ${p.validation.max})</#if>
    @VCompare(with = "begin${p.name?cap_first}"<#if p.label?? && (p.label?length > 0)>, withLabel = "${p.label}范围最小值"</#if>)<#if p.label?? && (p.label?length > 0)>
    @VField(label = "${p.label}<#if p.filter.region>范围最大值</#if>")</#if></#if>
    @RequestParam
    private ${p.type?cap_first}  end${p.name?cap_first};</#if>

    </#if></#if></#list></#if>

    <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
    public ${p.type?cap_first} get<#if p.filter.region>Begin${p.name?cap_first}<#else>${p.name?cap_first}</#if>() {
        return <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if>;
    }

    public void set<#if p.filter.region>Begin${p.name?cap_first}<#else>${p.name?cap_first}</#if>(${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if>) {
        this.<#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if> = <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if>;
    }

    <#if p.filter.region>
    public ${p.type?cap_first} get<#if p.filter.region>End${p.name?cap_first}<#else>${p.name?cap_first}</#if>() {
        return <#if p.filter.region>end${p.name?cap_first}<#else>${p.name}</#if>;
    }

    public void set<#if p.filter.region>End${p.name?cap_first}<#else>${p.name?cap_first}</#if>(${p.type?cap_first} <#if p.filter.region>end${p.name?cap_first}<#else>${p.name}</#if>) {
        this.<#if p.filter.region>end${p.name?cap_first}<#else>${p.name}</#if> = <#if p.filter.region>end${p.name?cap_first}<#else>${p.name}</#if>;
    }
    </#if></#if></#list></#if>
}