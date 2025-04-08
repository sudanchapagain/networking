#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>

#include <iostream>
#include <functional>

using websocketpp::connection_hdl;
typedef websocketpp::server<websocketpp::config::asio> server;

void on_message(server* s, websocketpp::connection_hdl hdl, server::message_ptr msg) {
    std::cout << "received: " << msg->get_payload() << std::endl;
    s->send(hdl, "hello from server", websocketpp::frame::opcode::text);
}

int main() {
    server echo_server;

    using namespace std::placeholders;

    try {
        echo_server.set_message_handler(
            std::bind(&on_message, &echo_server, _1, _2)
        );

        echo_server.init_asio();
        echo_server.listen(9002);
        echo_server.start_accept();

        std::cout << "websocket started on port 9002" << std::endl;
        echo_server.run();
    } catch (websocketpp::exception const & e) {
        std::cout << "Exception: " << e.what() << std::endl;
    }
}
