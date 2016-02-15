import SimpleHTTPServer
import SocketServer

PORT = 80

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("0.0.0.0", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()
