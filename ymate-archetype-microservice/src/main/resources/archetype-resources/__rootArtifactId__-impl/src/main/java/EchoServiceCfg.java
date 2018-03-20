#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import net.ymate.platform.configuration.annotation.Configuration;
import net.ymate.platform.configuration.impl.DefaultConfiguration;

/**
 * EchoServiceImpl Configuration.
 */
@Configuration("cfgs/echo.service.cfg.xml")
public class EchoServiceCfg extends DefaultConfiguration {
}
