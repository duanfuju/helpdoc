package cn.com.oking.services;


import java.io.FileInputStream;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import cn.com.oking.entity.SysFileInformation;

import com.bstek.bdf2.core.context.ContextHolder;

/**
 * Servlet implementation class DownloadServlet
 */
public class DownloadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DownloadServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
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
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		RequestDispatcher rd;
		response.reset();
		response.setContentType("application/x-download");
		request.setCharacterEncoding("UTF-8");
		
		//获取文件id参数
		String filedid = request.getParameter("filedid");
		//获取服务
		InfoConnectBasicServices sysdao=ContextHolder.getBean("infoConnectBasicServices");
		//根据文件的id查询文件字啊数据库中的所有数据
		SysFileInformation info = null;
		List<SysFileInformation> sl = sysdao.dealWhithSession(filedid);
		if(sl.size()>0){
			info = sl.get(0);
			
		}
		//准备下载的文件的存放路径
		String filedownloadpath=null;
		String fileName  = info.getFileName(); 
		//  文件的路径和默认保存名(真实名字)
		filedownloadpath=info.getSavaPath()+"\\"+info.getRealName();
		fileName = unicodeToStr(fileName);
		 File file = new File(filedownloadpath);
		 if(!file.exists()){
		    	file = null;
		    	request.setAttribute("error", "文件不存在！");
		    	rd = request.getRequestDispatcher("./downloaderr.jsp");
		    	rd.forward(request, response);
		 }else{
	        fileName = URLEncoder.encode(fileName,"UTF-8");
	        response.addHeader("Content-Disposition","attachment;filename="+ fileName );
	        
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
		        e.printStackTrace();
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
