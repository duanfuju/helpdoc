package cn.com.oking.util;

import java.util.ArrayList;
   
import cn.com.oking.util.Document;
  
  public class test
  {
	  public test(){
		  Document doc = null; 
		  try { 
			  doc = new Document(); 
			  doc.open("d:/czfa_jy.doc"); 
			  ArrayList tableData = new ArrayList(3); 
			  String[] title = { 
			  "���", "����", "����","��ַ"}; 
			  tableData.add(title); 
			  String[] field1 = { 
			  "1", "751002", "������ش�������������޹�˾�Զ�������ƽ̨","www.heavenlake.com"}; 
			  tableData.add(field1); 
			  String[] field2 = { 
			  "2", "751004", "��Ʒ���ݹ���ϵͳ","pdm.heavenlake.com"}; 
			  tableData.add(field2); 
			  doc.insertAtBookmark("PO_table",tableData,"�б��� 4"); 
		  } 
		  catch (Exception e) { 
			  e.printStackTrace(); 
		  } 
		  finally { 
			  try {
				doc.close(true);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		  }
	  }

   
	  public static void main(String[]args)
	  {
		  test test1=new test();
	  }
}
