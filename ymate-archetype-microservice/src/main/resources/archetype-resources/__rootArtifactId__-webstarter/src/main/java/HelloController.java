#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import net.ymate.platform.webmvc.annotation.Controller;
import net.ymate.platform.webmvc.annotation.RequestMapping;
import net.ymate.platform.webmvc.annotation.RequestParam;
import net.ymate.platform.webmvc.view.IView;
import net.ymate.platform.webmvc.view.View;
import net.ymate.port.annotation.Reference;

/**
 * Hello Controller
 */
@Controller
@RequestMapping("/hello")
public class HelloController {

    @Reference
    private IEchoService __service;

    @RequestMapping("/")
    public IView hello(@RequestParam String message) throws Exception {
        return View.textView(__service.echo(message));
    }
}
