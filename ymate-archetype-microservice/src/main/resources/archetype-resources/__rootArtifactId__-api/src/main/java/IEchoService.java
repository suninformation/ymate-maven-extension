#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

/**
 * IEchoService Interface.
 */
public interface IEchoService {

    /**
     * Echo Message.
     *
     * @param message Content
     * @return Return the received message content.
     */
    String echo(String message);
}
