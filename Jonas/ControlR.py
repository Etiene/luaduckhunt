from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
from SocketServer import ThreadingMixIn
import threading
import argparse
import re
import cgi
import os

import time
from Quartz.CoreGraphics import CGEventCreateMouseEvent
from Quartz.CoreGraphics import CGEventPost
from Quartz.CoreGraphics import kCGEventMouseMoved
from Quartz.CoreGraphics import kCGEventLeftMouseDown
from Quartz.CoreGraphics import kCGEventLeftMouseDown
from Quartz.CoreGraphics import kCGEventLeftMouseUp
from Quartz.CoreGraphics import kCGMouseButtonLeft
from Quartz.CoreGraphics import kCGHIDEventTap

from AppKit import NSScreen

print "width"
print NSScreen.mainScreen().frame().width
print "height"
print NSScreen.mainScreen().frame().height

def mouseEvent(type, posx, posy):
	theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)
	CGEventPost(kCGHIDEventTap, theEvent)
def mousemove(posx,posy):
	mouseEvent(kCGEventMouseMoved, posx,posy);
def mouseclick(posx,posy):
	#mouseEvent(kCGEventMouseMoved, posx,posy); #uncomment this line if you want to force the mouse to MOVE to the click location first (i found it was not necesary).
	mouseEvent(kCGEventLeftMouseDown, posx,posy);
	mouseEvent(kCGEventLeftMouseUp, posx,posy);

######

def moveMouse(coords):
	x = coords[0]
	y = coords[1]
	z = coords[2]
	#print x + ", " + y
	#mousemove(float(x),float(y))
	
def pressButton(button):
	print "Button " + button

class HTTPRequestHandler(BaseHTTPRequestHandler):

	def do_GET(self):
		if None != re.search('/api/values/*', self.path):
			words = self.path.split("/")
			if len(words[3]) > 2:
				coords = words[3].split(",")
				moveMouse(coords)
			else:
				button = words[3]
				pressButton(button)

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
	allow_reuse_address = True
 
	def shutdown(self):
		self.socket.close()
		HTTPServer.shutdown(self)
 
class SimpleHttpServer():
	def __init__(self, ip, port):
		self.server = ThreadedHTTPServer((ip,port), HTTPRequestHandler)
		print ip
		print port
 
	def start(self):
		self.server_thread = threading.Thread(target=self.server.serve_forever)
		self.server_thread.daemon = True
		self.server_thread.start()
 
	def waitForThread(self):
		self.server_thread.join()
 
	def stop(self):
		self.server.shutdown()
		self.waitForThread()
 
if __name__=='__main__':
	server = SimpleHttpServer('192.168.112.8', 1337)
	print 'HTTP Server Running...........'
	server.start()
	server.waitForThread()