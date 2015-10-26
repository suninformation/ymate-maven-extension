#set($symbol_pound='#')
#set($symbol_dollar='$')
#set($symbol_escape='\' )
package ${package};

import net.ymate.platform.core.YMP;

/**
 * DemoModule interface
 */
public interface IDemoModule {

    public static final String MODULE_NAME = "demomodule";

    public YMP getOwner();

    public IDemoModuleCfg getModuleCfg();

    public void sayHi(String youName);
}
