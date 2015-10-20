#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

/**
 * DemoModule interface
 */
public interface IDemoModule {

    public static final String MODULE_NAME = "demomodule";

    public IDemoModuleCfg getModuleCfg();

    public void sayHi(String youName);
}
