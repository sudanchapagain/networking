#set page(paper: "a4")
#set par(justify: true)
#set text(
  font: "New Computer Modern",
  size: 12pt
)

= Protocols

`[ [ip]  [udp]  [packet payload] ]`

- ip holds key info
- udp holds additional info
- packet payload is actual data

== IP & TCP

*Introduction to TCP/IP and Sockets:*
#link("https://www.youtube.com/playlist?list=PLbtjxiXev6lqCUaPWVMXaKxrJtHRRxcpM")

*IP RFC*
#link("https://datatracker.ietf.org/doc/html/rfc791")
#link("https://www.rfc-editor.org/rfc/pdfrfc/rfc791.txt.pdf")

*TCP/IP for programmers*
#link("https://www.youtube.com/watch?v=0OztKsGTqos")

*Internet Header Format*

A summary of the contents of the internet header follows:

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version|  IHL  |Type of Service|          Total Length         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Identification        |Flags|      Fragment Offset    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Time to Live |    Protocol   |         Header Checksum       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       Source Address                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Destination Address                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Options                    |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

version _4 bits_: which version of protocol

IHL _4 bits_: length of the internet header in 32 bit words

type of service _8 bits_: reliability or low delay or high throughput

total length _16 bits_: length of the datagram, measured in octets, including
internet header and data.  This field allows the length of a datagram to be up
to 65,535 octets

identification _16 bits_: identifying value assigned by the sender to aid in
assembling the fragments of a datagram.

flags _3 bits_: bit 0 is reserved (must be zero). Bit 1: (DF) 0 = May Fragment,
1 = Don't Fragment. Bit 2: (MF) 0 = Last Fragment, 1 = More Fragments.

```txt
  0   1   2
+---+---+---+
|   | D | M |
| 0 | F | F |
+---+---+---+
```

fragment offset _13 bits_: indicates where in the datagram this fragment
belongs.

time to live _8 bits_: how long we should try to get a packet from one place
to another. If this field contains the value zero, then the datagram must be
destroyed. every module that processes a datagram must decrease the TTL by at
least one even if it process the datagram in less than a second

protocol _8 bits_: indicates the next level protocol used in the data portion
of the internet datagram.  The values for various protocols are specified in
"Assigned Numbers".

header checksum _16 bits_: checksum on the header only.  Since some header
fields change (e.g., time to live), this is recomputed and verified at each
point that the internet header is processed. the checksum is 16 bit one's
complement of the one's complement sum of all 16 bit words in the header.

source & destination _32 bits each_: our and their ip.


*the IP's RFC 791 seems to be much more readable and no fluff. reading the
document itself is fine.*

`|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||`

IP is best effort delivery which means it might not get there or might not get
there in order that they were sent int.

the high level protocols have to handle this. i.e. sequence numbers,
re-transmission, etc.

== user datagram protocol (UDP)

adds port number for source and destination as with ip we already know
from which computer to which computer but not to which and from application.

it has ports (both), length, checksum.

== transmission control protocol (TCP)

breaks message into pieces. appends headers. assigns sequence numbers,
symbols, flags.

acknowledge is used. (ack)

one sends packet 1. second acks. one sends another so on.

the beginning of the tcp connection has to perform a handshake.

the handshake is done with special symbol SYN (synchronize), SYN-ACK, ACK.

...

tcp header has source port, destination port, sequence number, ack number, data
offset, reserved block, window, checksum, urgent pointer, options, padding,
flags.

== sockets

the level where as a programmer one starts interacting in most cases.

sockets represnt the applications portal / acces point / api into all the
protocol stacks.

```c
#include <sys/socket.h>

int socket (int domain, int type, int protocol);
```

domain is AF_INET-IPv4 or AF_INET-IPv6

tyle is SOCK_STREAM (reliable byte stream i.e. TCP) or SOCK_DGRAM (unreliable
datagrams i.e. UDP)

its like file handle but you dont use read write functions.

```c
// for client.
// socket connect at this socket
int connect(int socket, const struct sockaddr *address, socklen_t address_len);

// for server
// listen for start to listen
int listen(int socket, int backlog);
// when you detect a client incoming connection and to complete the
// connection you use accept
int accept(int socket, struct sockaddr *restrict address, socklen_t *restrict address_len);

// when actively connect to a socket you can use send and receive to send
// or receive data
ssize_t send(int socket, const void *buffer, size_t length, int flags);
ssize_t recv(int socket, void *buffer, size_t length, int flags);

// this is not closing socket. its half shutdown where you can shutdown for
// reads or write (represented in how)
int shutdown(int socket, int how);

// to actually close socket
int close(int socket);
```

socket names (addresses). socket represents apis into all protocols. socket
address represented adressing information port number, ip address. it is meant
to be generic structure that is to be specialized for specific protocol.

`<netinet/in.h>` header defines the `sockaddr_in` struct which is socket
address for internet protocol. ip.

== http

on top of tcp which follows a request-response model. it is stateless i.e. each
request is independent. sessions/cookies are used for continuity if needed.

HTTPS adds tls/ssl on top of http. HTTP/2 and HTTP/3 introduced multiplexing,
header compression, and connection management improvements.

== OSI Model

1. Physical: Bits, Media (copper, fiber, radio), NICs, Hubs 
2. Data Link: Physical Addressing, Switches, NICs 
3. Network: Logical Addressing, Routers                          
4. Transport: Ports, logical communication between application processes                                   
5. Session: open, close and manage sessions between end-user application processes
6. Presentation: file formats, compression
7. Application: Programs and Services

1. Physical: Encoding 1 and 0 s
2. Data Link: MAC addressing, Ethernet, WiFi, DSL, PPP,
3. Network: IPv4, IPv6, ICMP, ICMPv6, IPSec
4. Transport: TCP, UDP
5. Session: RTP, SOCKS
6. Presentation: MIME
7. Application: HTTP, HTTPS, DNS, FTP, SMTP, Telnet, SSH, DHCP, SSL/TLS

== TCP/IP Protocol Suite

*TCP/IP Protocol Suite   PDU        Header*

Application Layer        Data        Application specific fields   
Transport Layer          Segments    src & dst port numbers (host & service)
Internet Layer           Datagrams   src & dst ip addresses
Link Layer               Frames      src & dst mac addresses
