package com.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 
 * @title: 下载文件
 * @description: 传文件路径（wjlj）和文件名称（wjmc）下载对应文件
 * @date: 2012-12-13
 * @author: S.A
 */
@SuppressWarnings("serial")
public class DownloadServlet extends HttpServlet{
	public void doPost(HttpServletRequest request, HttpServletResponse response) 
		throws IOException, ServletException{
		doGet(request, response);
	}
	
	private String unicodeToStr(String uStr){
		String str="";
        //uStr=uStr.replaceAll("&#x","");
        //uStr=uStr.replaceAll("&#x00","");
        //uStr=uStr.substring(0,uStr.length()-1);            
        String[]arUstr=uStr.split("~u");
        for(int i=1;i<arUstr.length;i++){
        	int value=Integer.parseInt(arUstr[i],16);                
        	char c=(char)value;
        	str+=c;
        }
        return arUstr[0]+str;
    }
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) 
	 			throws IOException, ServletException {
		RequestDispatcher rd;
		response.reset();
		response.setContentType("application/x-download");
		request.setCharacterEncoding("UTF-8");
	    String filedownloadpath = request.getRealPath("/") + request.getParameter("wjlj");
	    String filedisplay = request.getParameter("wjmc");
	    filedisplay = unicodeToStr(filedisplay);
	    File file = new File(filedownloadpath);
	    if(!file.exists()){
	    	file = null;
	    	request.setAttribute("error", "文件不存在！");
	    	rd = request.getRequestDispatcher("./downloaderr.jsp");
	    	rd.forward(request, response);
	    }else{
	    
		    filedisplay = URLEncoder.encode(filedisplay,"UTF-8");
		    response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
			
		    OutputStream outp = null;
		    FileInputStream in = null;
		    
		    try{
		    	outp = response.getOutputStream();
		    	in = new FileInputStream(filedownloadpath);
		    	byte[] b = new byte[1024];
		    	int i = 0;
	          
		    	while((i = in.read(b)) > 0){
		    		outp.write(b, 0, i);
		    	}
		    	outp.flush();
		          
		    }catch(Exception e){
		        //e.printStackTrace();
		    }finally{
		        if(outp != null){
		        	outp.close();
		            outp = null;
		        }
		        if(in != null){
		    		response.setStatus(response.SC_OK);
		    	    response.flushBuffer();
		    		in.close();
		            in = null;
		        }
		    }
	    }
	}
	
}