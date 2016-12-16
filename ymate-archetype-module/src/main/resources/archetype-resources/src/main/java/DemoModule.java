#set($symbol_pound='#')
#set($symbol_dollar='$')
#set($symbol_escape='\' )
package ${package};

import ${package}.impl.DefaultDemoModuleCfg;
import net.ymate.platform.core.Version;
import net.ymate.platform.core.YMP;
import net.ymate.platform.core.module.IModule;
import net.ymate.platform.core.module.annotation.Module;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * DemoModule
 */
@Module
public class DemoModule implements IModule, IDemoModule {

    private static final Log _LOG = LogFactory.getLog(DemoModule.class);

    public static final Version VERSION = new Version(1, 0, 0, DemoModule.class.getPackage().getImplementationVersion(), Version.VersionType.Alphal);

    private static volatile IDemoModule __instance;

    private YMP __owner;

    private IDemoModuleCfg __moduleCfg;

    private boolean __inited;

    public static IDemoModule get() {
        if (__instance == null) {
            synchronized (VERSION) {
                if (__instance == null) {
                    __instance = YMP.get().getModule(DemoModule.class);
                }
            }
        }
        return __instance;
    }

    public static IDemoModule get(YMP owner) {
        return owner.getModule(DemoModule.class);
    }

    public String getName() {
        return IDemoModule.MODULE_NAME;
    }

    public void init(YMP owner) throws Exception {
        if (!__inited) {
            //
            _LOG.info("Initializing ${artifactId}-" + VERSION);
            //
            __owner = owner;
            __moduleCfg = new DefaultDemoModuleCfg(owner);
            //
            // Here to write your code
            //
            __inited = true;
        }
    }

    public boolean isInited() {
        return __inited;
    }

    public void destroy() throws Exception {
        if (__inited) {
            __inited = false;
            //
            // Here to write your code
            //
            __moduleCfg = null;
            __owner = null;
        }
    }

    public YMP getOwner() {
        return __owner;
    }

    public IDemoModuleCfg getModuleCfg() {
        return __moduleCfg;
    }

    public void sayHi(String youName) {
        System.out.println("Hi " + youName + ", " + getModuleCfg().getModuleParamTwo());
    }
}
