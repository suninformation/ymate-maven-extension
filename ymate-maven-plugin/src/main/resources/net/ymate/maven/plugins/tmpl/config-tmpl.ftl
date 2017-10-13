package ${packageName}<#if withInterface>.impl</#if>;

<#compress>
<#if withInterface>import ${packageName}.I${configName?cap_first};</#if>
import net.ymate.platform.configuration.annotation.Configuration;<#if !isXml>
import net.ymate.platform.configuration.annotation.ConfigurationProvider;
import net.ymate.platform.configuration.impl.PropertyConfigurationProvider;</#if>
import net.ymate.platform.configuration.impl.DefaultConfiguration;</#compress>

/**
 * ${configName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
<#compress>
@Configuration<#if (fileName??)>("${fileName}")</#if><#if !isXml>
@ConfigurationProvider(PropertyConfigurationProvider.class)</#if></#compress>
public class ${configName?cap_first} extends DefaultConfiguration<#if withInterface> implements I${configName?cap_first}</#if> {
}