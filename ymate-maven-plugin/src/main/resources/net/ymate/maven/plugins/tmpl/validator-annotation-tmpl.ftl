package ${packageName};

import java.lang.annotation.*;

/**
 * V${annotationName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface V${annotationName?cap_first} {

    /**
     * @return 自定义验证消息
     */
    String msg() default "";
}