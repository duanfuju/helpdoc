1.��web/WEB-INF/dorado-home/app-context.xml������
	 xmlns:task="http://www.springframework.org/schema/task"

	http://www.springframework.org/schema/task     
    	http://www.springframework.org/schema/task/spring-task-3.0.xsd

2.������Ҫʹ�õ���
	<bean id="serchRunServices" class="cn.com.oking.dataInterface.action.SerchRun" />  
	
3.ʹ��task��ǩ
	<task:scheduled-tasks> 
		 <task:scheduled ref="serchRunServices" method="timingMethod" cron="0 0/5 * * * ?" />
		</task:scheduled-tasks> 


4.����Cron���ʽ������:http://www.bejson.com/cronCreator/