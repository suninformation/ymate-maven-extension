#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.impl;

import ${package}.EchoServiceCfg;
import ${package}.IEchoService;
import net.ymate.platform.configuration.AbstractConfigurable;
import net.ymate.platform.configuration.annotation.Configurable;
import net.ymate.port.annotation.Service;
import org.apache.commons.lang.StringUtils;

/**
 * IEchoService Interface Default Implementation.
 */
@Service
@Configurable(type = EchoServiceCfg.class)
public class EchoServiceImpl extends AbstractConfigurable<EchoServiceCfg> implements IEchoService {

    @Override
    public String echo(String message) {
        String _echoStr = message;
        if (StringUtils.isBlank(_echoStr)) {
            _echoStr = getConfig().getString("echo_str", "None");
        }
        return "Echo: " + _echoStr;
    }
}
