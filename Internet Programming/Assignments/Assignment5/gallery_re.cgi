#!/usr/bin/python
import cgi
import cgitb
import os,sys
import Image
cgitb.enable()
UPLOAD_DIR = "pictures/"


dirs = os.listdir(UPLOAD_DIR)
pics =[]
for i in range(len(dirs)):
	size = (140, 140)
	im=Image.open("pictures/"+dirs[i])
	im.thumbnail(size)
	im.save(dirs[i], 'JPEG')
	pics.append(im)


p = 0
if 'HTTP_COOKIE' in os.environ:
	cookies = os.environ['HTTP_COOKIE']
	cookies = cookies.split('; ')
handler = {}
for cookie in cookies:
	cookie = cookie.split('=')
	handler[cookie[0]] = cookie[1]
for key,value in handler.iteritems():
	if key == "ROLE":
		print "content-type: text/html"
		print
		print "<!DOCTYPE html>"
		print "<html>"
		print "<head>"
		print "<meta charset= 'utf-8'>"
		print "<link rel='stylesheet' type='text/css' href='styles.css'>"
		print "<script type='text/javascript'>"

		print "function changeActiontoG()"
		print "{"
		print "var x = document.getElementById('myform')"
		print "x.action='gallery.cgi'"
		print "x.submit()"
		print "}"

		print "function changeActiontoU()"
		print "{"
		print "var x = document.getElementById('myform')"
		print "x.action='upload.cgi'"
		print "x.submit()"
		print "}"

		print "function changeActiontoD(i)"
		print "{"
		print "var x = document.getElementById(i)"
		print "x.action='delete.cgi'"
		print "x.submit()"
		print "}"

		print "function changeActiontoE(i)"
		print "{"
		print "var x = document.getElementById(i)"
		print "x.action='edit.cgi'"
		print "x.submit()"
		print "}"



		print "function bigpic(picname)"
		print "{"
		print "var big = document.createElement('div')"
		print "var pic = document.createElement('img')"
		print "var tit = document.createElement('p')"
		print "var t = document.createTextNode(picname)"
		print "tit.appendChild(t)"
		print "big.id = 'fullsize'"
		print "big.onclick = 'document.removeChild(big)'"
		print "big.addEventListener('click', function(){"
		print " this.parentNode.removeChild(this)})"
		print "pic.src='pictures/'+ picname"
		print "pic.alt='image'"
		print "big.appendChild(tit)"
		print "big.appendChild(pic)"
		print "document.body.appendChild(big)"
		print "}"

		print "</script>"
		print "</head>"

		print "<body>"
		print "<div align='center'>"
		print "<h1>Picture Gallery</h1>"
		print "<form action='gallery_re.cgi' method='POST' id='myform' enctype='multipart/form-data'>"
		print "<input type='submit' value='Refresh'>"
		print "</div>"

		print "<br/>"
		print "<br/>"
		print "</form>"

		print "<div id = 'main'>"
		for i in range(len(pics)):
			print "<div class='inner' name='"+dirs[i]+"'>"
			print "<br/>"
			print "<img id='im' src="+dirs[i]+" alt='image'  onclick='bigpic(\""+dirs[i]+"\")'/>"
			print "<br/>"
			print  dirs[i]
			print "<br/>"
			print "<br/>"
			print "<input type='hidden' name='dname' value='"+dirs[i]+"'>"
			print "</div>"
		print "</div>"

		print "</body>"
		print "</html>"
if p == 0 :
	print "content-type: text/html"
	print "Location:login.html"
 	print