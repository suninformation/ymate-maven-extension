#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.server;

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.support.Speedometer;
import net.ymate.platform.serv.IServerCfg;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.impl.DefaultServerCfg;
import net.ymate.platform.serv.impl.DefaultSessionIdleChecker;
import net.ymate.platform.serv.nio.codec.TextLineCodec;
import net.ymate.platform.serv.nio.datagram.INioUdpSessionListener;
import net.ymate.platform.serv.nio.datagram.NioUdpSessionManager;
import net.ymate.platform.serv.nio.datagram.NioUdpSessionWrapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;
import java.net.InetSocketAddress;

/**
 * UdpSessionListener
 */
public class UdpSessionListener implements INioUdpSessionListener<NioUdpSessionWrapper, String> {

    private static final Log _LOG = LogFactory.getLog(UdpSessionListener.class);

    public static void main(String[] args) throws Exception {
        // 初始化YMP框架
        YMP.get().init();
        // 创建服务端配置
        IServerCfg _serverCfg = DefaultServerCfg.create()
                .selectorCount(10)
//                .serverHost("localhost")
                .port(8281).build();
        // 通过会话管理器创建服务 (设置会话空闲时间为30秒)
        final NioUdpSessionManager<NioUdpSessionWrapper, String> _manager = new NioUdpSessionManager<NioUdpSessionWrapper, String>(_serverCfg, new TextLineCodec(), new UdpSessionListener(), 30000L);
        // 设置空闲会话检查服务
        _manager.idleChecker(new DefaultSessionIdleChecker<NioUdpSessionWrapper, InetSocketAddress, String>());
        // 设置流量速度计数器
        _manager.speedometer(new Speedometer());
        // 初始化并启动服务
        _manager.init(Servs.get());

        // -------------------

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(30000L);
                    // 遍历会话并向其发送消息
                    for (NioUdpSessionWrapper _session : _manager.sessionWrappers()) {
                        _manager.sendTo(_session.getId(), "Send message from server.");
                    }
                    // 当前会话总数
                    System.out.println("Current session count: " + _manager.sessionCount());
                    Thread.sleep(10000L);
                    // 将已连接的客户端会话从管理器中移除
                    for (NioUdpSessionWrapper _session : _manager.sessionWrappers()) {
                        _manager.closeSessionWrapper(_session);
                    }
                    Thread.sleep(10000L);
                    // 销毁会话管理器
                    _manager.destroy();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
    }

    @Override
    public Object onMessageReceived(NioUdpSessionWrapper sessionWrapper, String message) throws IOException {
        _LOG.info("onMessageReceived: " + message + " from " + sessionWrapper.getId());
        // 当收到消息后，可以直接向客户端回复消息
        return "Hi, " + sessionWrapper.getId();
    }

    @Override
    public void onExceptionCaught(NioUdpSessionWrapper sessionWrapper, Throwable e) throws IOException {
        _LOG.info("onExceptionCaught: " + e.getMessage() + " -- " + sessionWrapper.getId());
    }

    @Override
    public void onSessionIdleRemoved(NioUdpSessionWrapper sessionWrapper) {
        _LOG.info("onSessionIdleRemoved: " + sessionWrapper.getId());
    }
}
