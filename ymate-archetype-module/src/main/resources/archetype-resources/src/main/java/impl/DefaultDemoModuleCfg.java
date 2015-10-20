#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.impl;

import ${package}.IDemoModule;
import ${package}.IDemoModuleCfg;
import net.ymate.platform.core.YMP;
import net.ymate.platform.core.util.RuntimeUtils;
import org.apache.commons.lang.StringUtils;

import java.util.Map;

/**
 * Default implement for interface IDemoModuleCfg
 */
public class DefaultDemoModuleCfg implements IDemoModuleCfg {

    private String __moduleParamOne;

    private String __moduleParamTwo;

    public DefaultDemoModuleCfg(YMP owner) {
        Map<String, String> _moduleCfgs = owner.getConfig().getModuleConfigs(IDemoModule.MODULE_NAME);
        //
        __moduleParamOne = RuntimeUtils.replaceEnvVariable(StringUtils.defaultIfEmpty(_moduleCfgs.get("module_param_one"), "${symbol_dollar}{root}"));
        //
        __moduleParamTwo = _moduleCfgs.get("module_param_two");
    }

    public String getModuleParamOne() {
        return __moduleParamOne;
    }

    public String getModuleParamTwo() {
        return __moduleParamTwo;
    }
}
