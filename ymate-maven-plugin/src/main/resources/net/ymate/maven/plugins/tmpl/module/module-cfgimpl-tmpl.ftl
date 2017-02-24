package ${packageName}.impl;

import ${packageName}.I${moduleName?cap_first};
import ${packageName}.I${moduleName?cap_first}ModuleCfg;
import net.ymate.platform.core.YMP;

import java.util.Map;

/**
 * I${moduleName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
public class DefaultModuleCfg implements I${moduleName?cap_first}ModuleCfg {

    public DefaultModuleCfg(YMP owner) {
        Map<String, String> _moduleCfgs = owner.getConfig().getModuleConfigs(I${moduleName?cap_first}.MODULE_NAME);
    }
}