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
from Quartz.CoreGraphics import CGEventCreate
from Quartz.CoreGraphics import CGEventGetLocation

def getMousePosition():
	ourEvent = CGEventCreate(None);
	currentpos=CGEventGetLocation(ourEvent);
	return float(str(currentpos[0])), float(str(currentpos[1]))

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

old1 = [0.0,0.0]

def moveMouse(x,y):
	pX, pY = getMousePosition()
	dx = (x + 1000.0)/50.0 - 20.0
	dy = (y + 1000.0)/50.0 - 20.0
	
	mousemove(pX + dx, pY + dy)
	#print "d: " + str(dx) + ", " + str(dy)
		 
	
def pressButton(button):
	print "echo"
	if button == 1:
		pX, pY = getMousePosition()
		mouseclick(pX, pY)
	else:
		mousemove(700,450)


class HTTPRequestHandler(BaseHTTPRequestHandler):

	def do_GET(self):
		if None != re.search('/api/values/*', self.path):
			words = self.path.split("/")
			
			if len(words[3]) > 2:
				coords = words[3].split(",")
				#print "c: " + coords[0] + ", " + coords[1]
				moveMouse(float(coords[0]), (-1)*float(coords[1]))
			else:
				button = words[3]
				pressButton(float(button))

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