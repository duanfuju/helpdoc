package cn.com.oking.dataInterface.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
public class Pinger { 
	/**  * Ҫping������  */ 
	private String remoteIpAddress; 
	/**  * ����ping�Ĵ���  */ 
	private final int pingTimes; 
	/**  * ���ó�ʱ  */ 
	private int timeOut; 

	public Pinger(String remoteIpAddress, int pingTimes, int timeOut) 
	{ 
		super();  
		this.remoteIpAddress = remoteIpAddress;  
		this.pingTimes = pingTimes;  this.timeOut = timeOut; 
	}
	/**  * �����Ƿ���pingͨ  * @param server  * @param timeout  * @return  */ 
	public boolean isReachable() {  
		BufferedReader in = null;  
		Runtime r = Runtime.getRuntime();  
		// ��Ҫִ�е�ping����,��������windows��ʽ������  
		String pingCommand = "ping " + remoteIpAddress + " -n " + pingTimes    + " -w " + timeOut;  
		try {   
			// ִ�������ȡ���  
			System.out.println(pingCommand);   
			Process p = r.exec(pingCommand);   
			if (p == null) {    return false;   }   
			in = new BufferedReader(new InputStreamReader(p.getInputStream()));   
			// ���м�����,�������Ƴ���=23ms TTL=62�����Ĵ���   
			int connectedCount = 0;   
			String line = null;   
			while ((line = in.readLine()) != null) {    
				connectedCount += getCheckResult(line); 
			}
				// �����������=23ms TTL=62����������,���ֵĴ���=���Դ����򷵻���  
			return	connectedCount == pingTimes;  
				
			
		} catch (Exception ex) {  
			ex.printStackTrace();   
			// �����쳣�򷵻ؼ�   
			return false;  
		} finally {   
			try {    
				in.close();   
			} catch (IOException e) { 
				e.printStackTrace();  
			}  
		}
	}
	/**  * ��line����=18ms TTL=16����,˵���Ѿ�pingͨ,����1,��t����0.  
	 * @param line  
	 * @return  */
		private static int getCheckResult(String line) {  
			// System.out.println("����̨����Ľ��Ϊ:"+line);  
			Pattern pattern = Pattern.compile("(\\d+ms)(\\s+)(TTL=\\d+)",    
			Pattern.CASE_INSENSITIVE);  
			Matcher matcher = pattern.matcher(line); 
			while (matcher.find()) {  
				return 1; 
				}  
			return 0; 
		}
		public static void main(String[] args) {  
			Pinger p = new Pinger("192.168.0.12", 1, 5000);  
			System.out.println(p.isReachable()); 
		}
}