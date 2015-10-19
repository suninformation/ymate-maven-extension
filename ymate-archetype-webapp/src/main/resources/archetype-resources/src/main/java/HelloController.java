#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import net.ymate.platform.webmvc.annotation.Controller;
import net.ymate.platform.webmvc.annotation.RequestMapping;
import net.ymate.platform.webmvc.view.IView;
import net.ymate.platform.webmvc.view.View;

/**
 * Hello Controller
 */
@Controller
@RequestMapping("/hello")
public class HelloController {

    @RequestMapping("/")
    public IView hello() throws Exception {
        return View.textView("Hello YMP world!");
    }
}
