package cn.com.oking;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;

import com.bstek.bdf2.core.context.ContextHolder;


public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public LoginServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//���ñ���Ϊutf-8
		response.setContentType("text/html;charset=utf-8");
		response.setCharacterEncoding("utf-8");
		request.setCharacterEncoding("utf-8");
		//��ȡ�ı����
		PrintWriter out=response.getWriter();
		//spring�ļ�����
		ShaPasswordEncoder passwordEncoder=new ShaPasswordEncoder();
		//��ȡ����
		String username=request.getParameter("username");
		String pwd=request.getParameter("pwd");
		//��ȡ����Դ
		JdbcTemplate jdbcT=ContextHolder.getBean("jdbcTemplate");
		String sql="select username_,password_,salt_ from bdf2_user where username_='"+username+"'";
		Map<String, Object> map=null;
		try {
			map = jdbcT.queryForMap(sql);
		} catch (DataAccessException e) {
			e.printStackTrace();
			map=new HashMap<String, Object>();
		}
		//��������ݵ����
		if (map.size()>0) {
			//��֤����
			if (passwordEncoder.isPasswordValid(map.get("password_").toString(), pwd,map.get("salt_").toString())) {
				out.print("<script type='text/javascript'>alert('��½�ɹ�������');location.href='com.oking.core.frame.main.MainFrame.d'</script>");
			}else{
				out.print("<script type='text/javascript'>alert('������󣡣���');location.href='Login.jsp'</script>");
			}
		}else{
			out.print("<script type='text/javascript'>alert('�޴��û�������');location.href='Login.jsp'</script>");
		}
	}

}
