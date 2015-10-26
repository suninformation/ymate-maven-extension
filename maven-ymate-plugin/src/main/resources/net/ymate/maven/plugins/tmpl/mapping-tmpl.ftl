
    <#if (mapping?? && mapping.mapping??)><#compress><@compress single_line=true><#if (mapping?? && mapping.mapping??)>@RequestMapping(value = "${mapping.mapping}"<#if (mapping.method?size > 0)>, method = {<#list mapping.method as m>Type.HttpMethod.${m?upper_case}<#if m_has_next>, </#if></#list>}</#if>
    <#if (mapping.header?size > 0)>, header = {<#list mapping.header as h>"${h}"<#if h_has_next>, </#if></#list>}</#if>
    <#if (mapping.param?size > 0)>, param = {<#list mapping.param as p>"${p}"<#if p_has_next>, </#if></#list>}</#if>)</#if></@compress>
    <#if (transaction)>@Transaction</#if>
    <#if (fileUpload)>@FileUpload</#if></#compress>
    public IView __${method.name?uncap_first}(<#list method.param as p>${p}<#if p_has_next>, </#if></#list>) throws Exception {
        return View.textView("mapping: ${mapping.mapping}");
    }</#if>

