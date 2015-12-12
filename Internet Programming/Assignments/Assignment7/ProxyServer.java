//Qike Zhang 5131953
//Hao Wang 5086487
//If the URI doesn't include file extension, I assume the content-type is "text/html".
//There is a redirect problem when we visit www.sco.com.
import java.net.*;
import java.io.*;
import java.util.*;
import java.text.DateFormat;

public class ProxyServer extends Thread {
	protected Socket s;
	int streamPosition = 0;
	String host;
	int port;
	OutputStream rawOut;
	InputStream rawIn;
	Socket serverConnection;
	byte requestBuffer[] = new byte[8192];
	int storedCount = 0;
	int consumedCount = 0;
	String log;

	ProxyServer(Socket s) {
		System.out.println("New client.");
		this.s = s;
	}

	protected Socket connectToServer() throws IOException {
		System.out.println("Connecting to " + host + ":" + port + "..");
		Socket socket = new Socket(host, port);
		System.out.println("Connected.");

		rawOut = socket.getOutputStream();
		rawIn = socket.getInputStream();
		return socket;
	}

	public void run() {
		StringTokenizer st;
		URL resourceURL;

		/******************************************************************/
		/* Use this byte array to store the headers temporarily */
		/* These headers are printed for debugging */

		ByteArrayOutputStream headerBuf = new ByteArrayOutputStream(8096);
		PrintWriter headerWriter = new PrintWriter(headerBuf); 

		/******************************************************************/

		try {
			InputStream istream = s.getInputStream();
			OutputStream ostream = s.getOutputStream();
		
			BufferedReader br = new BufferedReader(new InputStreamReader(istream));

			/********************************************************************************/
			/* Read Input Request Lines */
			/********************************************************************************/

			String requestLine;
			String resourcePath;
			String filePath="";
			String urlPath;
			String contentType="text/html";
			String uri="";
			log="*******request header:start*******\n";
			
			String line = "";
			if ((line = br.readLine()) != null) {
				requestLine = line;
			} else {
				throw new IOException("End of buffer!");
			}
			System.out.println(requestLine);
			headerWriter.println(requestLine);
			
			log=log+requestLine+'\n';

			st = new StringTokenizer(requestLine);
			String request = st.nextToken(); /* GET, HEAD */

			System.out.println("#DEBUG MESSAGE: Request Method =" + request);

			if (request.equals("GET") || request.equals("HEAD")) {
				
				uri = st.nextToken(); /* / URI */
				String protocol = st.nextToken(); /* HTTP1.1 or HTTP1.0 */

				if (uri.startsWith("http")) {
					/* It is a full URL. So get the file path */
					resourceURL = new URL(uri);
					filePath = resourceURL.getPath();
					String fileName[] = filePath.split("\\.");
					if(fileName.length==2)
						contentType=convertToMIME(fileName[1]);
					host = resourceURL.getHost();
					port = resourceURL.getPort();
					if (port == -1) {
						port = 80;
					}
					System.out.println("#DEBUG MESSAGE: Request URI = " + filePath);
				}
				urlPath = uri;
			}
			if ((line = br.readLine()) != null) {
				requestLine = line;
			} else {
				throw new IOException("End of buffer!");
			}

			st = new StringTokenizer(requestLine, ": ");
			String fieldName = st.nextToken(); /* Expect HOST field */
			
			if (fieldName.equals("Host")) {
				host = st.nextToken();
				
				String portString = new String("");
				
				try {
					portString = st.nextToken();
				} catch (Exception NoSuchElement) {
				}
				if (portString.length() == 0) {
					port = 80;
				} else
					port = Integer.parseInt(portString);

				System.out.println("#DEBUG MESSAGE  - Host = " + host + " port number = " + port);
			}
			
			while (requestLine.length() != 0) {
				requestLine=removeHopToHopHeaders(requestLine);
				
				if(requestLine.length() != 0){
					headerWriter.println(requestLine);
					log=log+requestLine+'\n';
				}
				if ((line = br.readLine()) != null) {	
					requestLine = line;
				} else {
					throw new IOException("End of buffer!");
				}
			}

			headerWriter.flush();
			
			log=log+"*******request header:end******\n";
			log=log+"Host = " + host + " Content-Type = " + contentType+'\n';
			if (!request.equals("GET") && !request.equals("HEAD"))
				throw new myException(ostream,"406");
			String result = check(host,contentType);
			if (result.equals("blocked")){
				log+="Disallowed\n";
				log = log + uri + "::blocked\n\n";
				throw new myException(ostream,"403");
			}
			if (result.equals("type")){
				log+="Disallowed\n";
				log = log + uri + "::File type not allowed\n\n";
				throw new myException(ostream,"403");
			}
			log+="Allowed\n\n";
			writeLog(log);
			
			/********************************************************************************/
			/* Open connection to the server host */
			/********************************************************************************/
			
			log="*******response header:start*******\n";
			
			String terminator;
			serverConnection = connectToServer();
			if (request.equals("GET") || request.equals("HEAD")) {
				terminator = new String("Connection:close\n\n");
			} else {
				terminator = new String("\n");
			}
			rawOut.write((headerBuf.toString()).getBytes()); 
			rawOut.write(terminator.getBytes()); 
			
			
			/* read response header*/
			DataInputStream in = new DataInputStream (rawIn);
			
			String response="";
			contentType="";
			
			while ((line = in.readLine()) != null){
				if(line.length()==0)
					break;
				line=removeHopToHopHeaders(line);
				if(line.length()!=0){
					log=log+line+'\n';
					response=response+line+'\n';
					if (line.split(":")[0].trim().equals("Content-Type"))
						contentType=line.split(":")[1].split(";")[0].trim();
				}
			}
			
			log=log+"*******response header:end******\n";
			result = check(host,contentType);
			if (result.equals("blocked")){
				log+="Disallowed\n";
				log = log + uri + "::blocked\n\n";
				throw new myException(ostream,"403");
			}
			if (result.equals("type")){
				log+="Disallowed\n";
				log = log + uri + "::File type not allowed\n\n";
				throw new myException(ostream,"403");
			}
			response+='\n';
			ostream.write(response.getBytes());
			
			byte buffer[] = new byte[8192];
			int count;
			
			while ((count = rawIn.read(buffer, 0, 8192)) > -1) {
				ostream.write(buffer, 0, count);
			}
			
			writeLog(log);
					
			serverConnection.close();
			
		} catch (IOException ex) {
			ex.printStackTrace();
		} catch (myException ex) {
			writeLog(log);
		} finally{
			try{
				System.out.println("Client exit.");
				System.out.println("---------------------------------------------------");
				s.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
	}
	
	public synchronized void writeLog(String message){
		
		try{
			File file = new File("log.txt");
			if(!file.exists())
				file.createNewFile();
			FileOutputStream fos =new FileOutputStream(file,true);
			fos.write((message+"\n").getBytes());
			fos.close();
		}
		catch(IOException ex){
			ex.printStackTrace();
		}
		
	}
	public String check(String host, String file){
		
		String text="";
		String result = "";
		try {
			FileReader fileReader = new FileReader("config.txt");
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			while((text = bufferedReader.readLine()) != null) {
				if(!text.startsWith("#")){
					String block[] = text.split(" ");
					if(block.length==1){
						ArrayList<String> list = new ArrayList<String>(Arrays.asList(block));
						list.add("*");
						block = list.toArray(new String[2]);
					}			
					if(host.equals(block[0]))
						if(block[1].equals("*"))
							result = "blocked";
						else{
							String type[] = block[1].split("/");
							String content[] = file.split("/");
							if(!file.equals(""))
								if(type[0].equals(content[0]) && (type[1].equals(content[1]) || type[1].equals("*")))
									result = "type";
						}
				}
			}   
			bufferedReader.close();         
		}catch (IOException ex) {
			ex.printStackTrace();
		}
		finally{
			return result;
		}
	}
	public String removeHopToHopHeaders(String requestLine){	
		String header = requestLine.split(":")[0].trim();
		switch(header){
			case	"Connection":
			case	"Keep-Alive":
			case	"Proxy-Authenticate":
			case	"Proxy-Authorization":
			case	"TE":
			case	"Trailers":
			case	"Transfer-Encoding":
			case	"Upgrade":
			return "";
		}
		return requestLine;
	}
	public String convertToMIME(String name){		
		switch(name){
			case	"ai": return	"application/postscript";
			case	"aif": return	"audio/x-aiff";
			case	"aifc": return	"audio/x-aiff";
			case	"aiff": return	"audio/x-aiff";
			case	"asc": return	"text/plain";
			case	"atom": return	"application/atom+xml";
			case	"au": return	"audio/basic";
			case	"avi": return	"video/x-msvideo";
			case	"bcpio": return	"application/x-bcpio";
			case	"bin": return	"application/octet-stream";
			case	"bmp": return	"image/bmp";
			case	"cdf": return	"application/x-netcdf";
			case	"cgm": return	"image/cgm";
			case	"class": return	"application/octet-stream";
			case	"cpio": return	"application/x-cpio";
			case	"cpt": return	"application/mac-compactpro";
			case	"csh": return	"application/x-csh";
			case	"css": return	"text/css";
			case	"dcr": return	"application/x-director";
			case	"dif": return	"video/x-dv";
			case	"dir": return	"application/x-director";
			case	"djv": return	"image/vnd.djvu";
			case	"djvu": return	"image/vnd.djvu";
			case	"dll": return	"application/octet-stream";
			case	"dmg": return	"application/octet-stream";
			case	"dms": return	"application/octet-stream";
			case	"doc": return	"application/msword";
			case	"dtd": return	"application/xml-dtd";
			case	"dv": return	"video/x-dv";
			case	"dvi": return	"application/x-dvi";
			case	"dxr": return	"application/x-director";
			case	"eps": return	"application/postscript";
			case	"etx": return	"text/x-setext";
			case	"exe": return	"application/octet-stream";
			case	"ez": return	"application/andrew-inset";
			case	"gif": return	"image/gif";
			case	"gram": return	"application/srgs";
			case	"grxml": return	"application/srgs+xml";
			case	"gtar": return	"application/x-gtar";
			case	"hdf": return	"application/x-hdf";
			case	"hqx": return	"application/mac-binhex40";
			case	"htm": return	"text/html";
			case	"html": return	"text/html";
			case	"ice": return	"x-conference/x-cooltalk";
			case	"ico": return	"image/x-icon";
			case	"ics": return	"text/calendar";
			case	"ief": return	"image/ief";
			case	"ifb": return	"text/calendar";
			case	"iges": return	"model/iges";
			case	"igs": return	"model/iges";
			case	"jnlp": return	"application/x-java-jnlp-file";
			case	"jp2": return	"image/jp2";
			case	"jpe": return	"image/jpeg";
			case	"jpeg": return	"image/jpeg";
			case	"jpg": return	"image/jpeg";
			case	"js": return	"application/x-javascript";
			case	"kar": return	"audio/midi";
			case	"latex": return	"application/x-latex";
			case	"lha": return	"application/octet-stream";
			case	"lzh": return	"application/octet-stream";
			case	"m3u": return	"audio/x-mpegurl";
			case	"m4a": return	"audio/mp4a-latm";
			case	"m4b": return	"audio/mp4a-latm";
			case	"m4p": return	"audio/mp4a-latm";
			case	"m4u": return	"video/vnd.mpegurl";
			case	"m4v": return	"video/x-m4v";
			case	"mac": return	"image/x-macpaint";
			case	"man": return	"application/x-troff-man";
			case	"mathml": return	"application/mathml+xml";
			case	"me": return	"application/x-troff-me";
			case	"mesh": return	"model/mesh";
			case	"mid": return	"audio/midi";
			case	"midi": return	"audio/midi";
			case	"mif": return	"application/vnd.mif";
			case	"mov": return	"video/quicktime";
			case	"movie": return	"video/x-sgi-movie";
			case	"mp2": return	"audio/mpeg";
			case	"mp3": return	"audio/mpeg";
			case	"mp4": return	"video/mp4";
			case	"mpe": return	"video/mpeg";
			case	"mpeg": return	"video/mpeg";
			case	"mpg": return	"video/mpeg";
			case	"mpga": return	"audio/mpeg";
			case	"ms": return	"application/x-troff-ms";
			case	"msh": return	"model/mesh";
			case	"mxu": return	"video/vnd.mpegurl";
			case	"nc": return	"application/x-netcdf";
			case	"oda": return	"application/oda";
			case	"ogg": return	"application/ogg";
			case	"pbm": return	"image/x-portable-bitmap";
			case	"pct": return	"image/pict";
			case	"pdb": return	"chemical/x-pdb";
			case	"pdf": return	"application/pdf";
			case	"pgm": return	"image/x-portable-graymap";
			case	"pgn": return	"application/x-chess-pgn";
			case	"pic": return	"image/pict";
			case	"pict": return	"image/pict";
			case	"png": return	"image/png";
			case	"pnm": return	"image/x-portable-anymap";
			case	"pnt": return	"image/x-macpaint";
			case	"pntg": return	"image/x-macpaint";
			case	"ppm": return	"image/x-portable-pixmap";
			case	"ppt": return	"application/vnd.ms-powerpoint";
			case	"ps": return	"application/postscript";
			case	"qt": return	"video/quicktime";
			case	"qti": return	"image/x-quicktime";
			case	"qtif": return	"image/x-quicktime";
			case	"ra": return	"audio/x-pn-realaudio";
			case	"ram": return	"audio/x-pn-realaudio";
			case	"ras": return	"image/x-cmu-raster";
			case	"rdf": return	"application/rdf+xml";
			case	"rgb": return	"image/x-rgb";
			case	"rm": return	"application/vnd.rn-realmedia";
			case	"roff": return	"application/x-troff";
			case	"rtf": return	"text/rtf";
			case	"rtx": return	"text/richtext";
			case	"sgm": return	"text/sgml";
			case	"sgml": return	"text/sgml";
			case	"sh": return	"application/x-sh";
			case	"shar": return	"application/x-shar";
			case	"silo": return	"model/mesh";
			case	"sit": return	"application/x-stuffit";
			case	"skd": return	"application/x-koan";
			case	"skm": return	"application/x-koan";
			case	"skp": return	"application/x-koan";
			case	"skt": return	"application/x-koan";
			case	"smi": return	"application/smil";
			case	"smil": return	"application/smil";
			case	"snd": return	"audio/basic";
			case	"so": return	"application/octet-stream";
			case	"spl": return	"application/x-futuresplash";
			case	"src": return	"application/x-wais-source";
			case	"sv4cpio": return	"application/x-sv4cpio";
			case	"sv4crc": return	"application/x-sv4crc";
			case	"svg": return	"image/svg+xml";
			case	"swf": return	"application/x-shockwave-flash";
			case	"t": return	"application/x-troff";
			case	"tar": return	"application/x-tar";
			case	"tcl": return	"application/x-tcl";
			case	"tex": return	"application/x-tex";
			case	"texi": return	"application/x-texinfo";
			case	"texinfo": return	"application/x-texinfo";
			case	"tif": return	"image/tiff";
			case	"tiff": return	"image/tiff";
			case	"tr": return	"application/x-troff";
			case	"tsv": return	"text/tab-separated-values";
			case	"txt": return	"text/plain";
			case	"ustar": return	"application/x-ustar";
			case	"vcd": return	"application/x-cdlink";
			case	"vrml": return	"model/vrml";
			case	"vxml": return	"application/voicexml+xml";
			case	"wav": return	"audio/x-wav";
			case	"wbmp": return	"image/vnd.wap.wbmp";
			case	"wbmxl": return	"application/vnd.wap.wbxml";
			case	"wml": return	"text/vnd.wap.wml";
			case	"wmlc": return	"application/vnd.wap.wmlc";
			case	"wmls": return	"text/vnd.wap.wmlscript";
			case	"wmlsc": return	"application/vnd.wap.wmlscriptc";
			case	"wrl": return	"model/vrml";
			case	"xbm": return	"image/x-xbitmap";
			case	"xht": return	"application/xhtml+xml";
			case	"xhtml": return	"application/xhtml+xml";
			case	"xls": return	"application/vnd.ms-excel";
			case	"xml": return	"application/xml";
			case	"xpm": return	"image/x-xpixmap";
			case	"xsl": return	"application/xml";
			case	"xslt": return	"application/xslt+xml";
			case	"xul": return	"application/vnd.mozilla.xul+xml";
			case	"xwd": return	"image/x-xwindowdump";
			case	"xyz": return	"chemical/x-xyz";
			case	"zip": return	"application/zip";
			default:	return	"text/html";
		}
	}
	public static void main(String args[]) throws IOException {
		if (args.length != 1)
			throw new RuntimeException("Syntax: HTTPTunnel port-number");
		File file = new File("log.txt");  
		if(!file.exists()) {  
			try {  
				file.createNewFile();
			} catch (IOException e) {  
				e.printStackTrace();  
			}  
        }  
		
		System.out.println("Starting on port " + args[0]);
		ServerSocket server = new ServerSocket(Integer.parseInt(args[0]));

		while (true) {
			System.out.println("Waiting for a client request");
			Socket client = server.accept();
			System.out.println("*********************************");
			System.out.println("Received request from "+ client.getInetAddress());
			ProxyServer c = new ProxyServer(client);
			c.start();
		}
	}
}

class myException extends Exception{
	public OutputStream ostream;
	public String status;
	myException(OutputStream ostream,String status){
		try{
			this.status=status;
			this.ostream=ostream;
			if(status.equals("406")){
				String str="HTTP/1.1 406 Not Acceptable\n\n";
				str+="<html>406 Not Acceptable</html>";
				ostream.write(str.getBytes());
			}else if(status.equals("403")){
				String str="HTTP/1.1 403 Forbidden\n\n";
				str+="<html>403 Forbidden</html>";
				ostream.write(str.getBytes());
			}
		}catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
