#set($symbol_pound='#')
#set($symbol_dollar='$')
#set($symbol_escape='\' )
package ${package};

import net.ymate.platform.core.YMP;

/**
 * DemoModule interface
 */
public interface IDemoModule {

    String MODULE_NAME = "demomodule";

    YMP getOwner();

    IDemoModuleCfg getModuleCfg();

    void sayHi(String youName);
}
