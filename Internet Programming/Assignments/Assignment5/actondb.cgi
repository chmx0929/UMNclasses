#!/usr/bin/python
import cgi
import os,sys
import cgitb; cgitb.enable()
import Cookie
import time
import MySQLdb

f = open("config.txt")
line1 = f.readline()
line1 = line1[:-1]
user = line1.split(':')
line2 = f.readline()
line2 = line2[:-1]
pasd = line2.split(':')
line3 = f.readline()
line3 = line3[:-1]
time = line3.split(':')
f.close()

db = MySQLdb.connect(host='egon.cs.umn.edu', user=""+user[1]+"",passwd=""+pasd[1]+"", port=3307,db=""+user[1]+"")
cursor = db.cursor()
p = 0
form = cgi.FieldStorage()
if form.has_key("adduser") and form.has_key("addpasd"):
	adduser = form['adduser'].value
	addpasd = form['addpasd'].value
	check = "SELECT Role FROM Users WHERE Name = '"+adduser+"'"
	exist = cursor.execute(check)
	if exist == 1 :
		print "content-type: text/html"
		print
		print "<!DOCTYPE html>"
		print "<html><head><title>File Upload</title>"
		print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		print "</head>"
		print "<body align = 'center'>"
		print "fail<br/>"
		print "<form action = 'owner.cgi'>"
		print "<input type='submit' value ='back'>"
		print "</form>"
		print "</body>"
		print "</html>"
		p = 1
	else :
		query = "INSERT INTO Users (Name,Role,Password) VALUES ('"+adduser+"','visitor','"+addpasd+"')"
		cursor.execute(query)
		db.commit()

if form.has_key("usr") and form.has_key("psd"):
	usr = form['usr'].value
	psd = form['psd'].value
	query = "UPDATE Users SET Password = '"+psd+"' WHERE Name = '"+usr+"'"
	cursor.execute(query)
	db.commit()

if form.has_key("deluser"):
	deluser = form['deluser'].value
	check = "SELECT Role FROM Users WHERE Name = '"+deluser+"'"
	cursor.execute(check)
	for row in cursor :
		if row[0] == 'owner' :
			print "content-type: text/html"
			print
			print "<!DOCTYPE html>"
			print "<html><head><title>File Upload</title>"
			print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
			print "</head>"
			print "<body align = 'center'>"
			print "fail<br/>"
			print "<form action = 'owner.cgi'>"
			print "<input type='submit' value ='back'>"
			print "</form>"
			print "</body>"
			print "</html>"
			p = 1
		else :
			query = "DELETE FROM Users WHERE Name = '"+deluser+"'"
			cursor.execute(query)
			db.commit()
if p == 0:
	print "content-type: text/html"
	print
	print "<!DOCTYPE html>"
	print "<html><head><title>File Upload</title>"
	print "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	print "</head>"
	print "<body align = 'center'>"
	print "success<br/>"
	print "<form action = 'owner.cgi'>"
	print "<input type='submit' value ='back'>"
	print "</form>"
	print "</body>"
	print "</html>"