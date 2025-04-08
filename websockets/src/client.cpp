#include <websocketpp/config/asio_no_tls_client.hpp>
#include <websocketpp/client.hpp>

typedef websocketpp::client<websocketpp::config::asio_client> client;

void on_message(websocketpp::connection_hdl, client::message_ptr msg) {
    std::cout << "server says: " << msg->get_payload() << std::endl;
}

int main() {
    client c;

    try {
        c.set_message_handler(&on_message);
        c.init_asio();

        websocketpp::lib::error_code ec;
        client::connection_ptr con = c.get_connection("ws://localhost:9002", ec);

        if (ec) {
            std::cout << "Connect initialization error: " << ec.message() << std::endl;
            return 0;
        }

        con->set_open_handler([&c](websocketpp::connection_hdl hdl) {
            c.send(hdl, "hello from client", websocketpp::frame::opcode::text);
        });


        c.connect(con);
        c.run();
    } catch (websocketpp::exception const & e) {
        std::cout << "Exception: " << e.what() << std::endl;
    }
}

