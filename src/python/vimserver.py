#!/usr/bin/python
#
# Server that will accept connections from a Vim channel.
# Run this server and then in Vim you can open the channel:
#  :let handle = ch_open('localhost:8765')
#
# Then Vim can send requests to the server:
#  :let response = ch_sendexpr(handle, 'hello!')
#
# And you can control Vim by typing a JSON message here, e.g.:
#   ["ex","echo 'hi there'"]
#
# There is no prompt, just type a line and press Enter.
# To exit cleanly type "quit<Enter>".
#
# See ":help channel-demo" in Vim.
#
# This requires Python 2.6 or later.

import json
import socket
import sys
import threading

import socketserver


class NameSpace(object):
    thesocket = None


name_space = NameSpace()


class ThreadedTCPRequestHandler(socketserver.BaseRequestHandler):
    def handle(self):
        print("=== socket opened ===")
        name_space.thesocket = self.request
        while True:
            try:
                data = self.request.recv(4096).decode("utf-8")
            except socket.error:
                print("=== socket error ===")
                break
            except IOError:
                print("=== socket closed ===")
                break
            if data == "":
                print("=== socket closed ===")
                break
            print("received: {0}".format(data))
            try:
                decoded = json.loads(data)
            except ValueError:
                print("json decoding failed")
                decoded = [-1, ""]

            # Send a response if the sequence number is positive.
            # Negative numbers are used for "eval" responses.
            if decoded[0] >= 0:
                if decoded[1] == "hello!":
                    response = "got it"
                else:
                    response = "what?"
                encoded = json.dumps([decoded[0], response])
                print("sending {0}".format(encoded))
                self.request.sendall(encoded.encode("utf-8"))
        name_space.thesocket = None


class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass


if __name__ == "__main__":
    HOST, PORT = "localhost", 8765

    server = ThreadedTCPServer((HOST, PORT), ThreadedTCPRequestHandler)
    ip, port = server.server_address

    # Start a thread with the server -- that thread will then start one
    # more thread for each request
    server_thread = threading.Thread(target=server.serve_forever)

    # Exit the server thread when the main thread terminates
    server_thread.daemon = True
    server_thread.start()
    print("Server loop running in thread: ", server_thread.name)

    print("Listening on port {0}".format(PORT))
    while True:
        typed = sys.stdin.readline()
        if "quit" in typed:
            print("Goodbye!")
            break
        if name_space.thesocket is None:
            print("No socket yet")
        else:
            print("sending {0}".format(typed))
            name_space.thesocket.sendall(typed.encode("utf-8"))

    server.shutdown()
    server.server_close()
