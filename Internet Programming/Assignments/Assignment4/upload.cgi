#!/usr/bin/python
import cgi
import cgitb
import os,sys
import Image
cgitb.enable()
UPLOAD_DIR = "/home/wang5167/.www/pictures"


def print_HTML():
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<link rel='stylesheet' type='text/css' href='styles.css'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('uploadform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Upload a New JPEG Picture</h1>"
	print "<div class='setborder'>"
	print "<br/>"
	print "<form action='upload.cgi' id= 'uploadform' method='POST' enctype='multipart/form-data'>"
	print "Title: <input type ='text' id='title' name ='title' ><br/><br/>"
	print "File:  <input type ='file' id='file_input' name = 'file_input' accept='.JPEG'><br/><br/>"
	print "<input  type = 'submit'  value ='Upload' id='upload' >"
	print "<input  type = 'button'  value ='Cancel' onclick='cancel()'>"
	print "</form>"
	print "</div>"
	print "</body>"
	print "</html>"

def print_HTML_Empty():
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "<link rel='stylesheet' type='text/css' href='styles.css'>"
	print "<script type='text/javascript'>"
	print "function cancel()"
	print "{"
	print "var x = document.getElementById('uploadform')"
	print "x.action='gallery.cgi'"
	print "x.submit()"
	print "}"
	print "</script>"
	print "</head>"
	print "<body align = 'center'>"
	print "<h1>Upload a New JPEG Picture</h1>"
	print "<div class='setborder'>"
	print "<p style='color:red;'>Picture Title Cannot Be Empty</p>"
	print "<form action='upload.cgi' id= 'uploadform' method='POST' enctype='multipart/form-data'>"
	print "Title: <input type ='text' id='title' name ='title' ><br/><br/>"
	print "File:  <input type ='file' id='file_input' name = 'file_input' accept='.JPEG'><br/><br/>"
	print "<input  type = 'submit'  value ='Upload' id='upload' >"
	print "<input  type = 'button'  value ='Cancel' onclick='cancel()'>"
	print "</form>"
	print "</div>"
	print "</body>"
	print "</html>"

def save_uploaded_file (form_field, upload_dir):
	form = cgi.FieldStorage()
	if form.has_key('title') and len(form['title'].value) ==0:
		print_HTML_Empty()
		return
	if not form.has_key(form_field):
		print_HTML()
		return
 	fileitem = form[form_field]
 	if not fileitem.file or len(fileitem.filename) ==0:
 		print_HTML()
 		return
 	fout = file (os.path.join(upload_dir, form['title'].value), 'w')
 	while 1:
 		chunk = fileitem.file.read(100000)
 		if not chunk: break
 		fout.write (chunk)
 	fout.close()
 	print "Location:gallery.cgi"
 	print_HTML()

print "content-type: text/html"
save_uploaded_file ("file_input", UPLOAD_DIR)