1.在web/WEB-INF/dorado-home/app-context.xml中配置
	 xmlns:task="http://www.springframework.org/schema/task"

	http://www.springframework.org/schema/task     
    	http://www.springframework.org/schema/task/spring-task-3.0.xsd

2.定义需要使用的类
	<bean id="serchRunServices" class="cn.com.oking.dataInterface.action.SerchRun" />  
	
3.使用task标签
	<task:scheduled-tasks> 
		 <task:scheduled ref="serchRunServices" method="timingMethod" cron="0 0/5 * * * ?" />
		</task:scheduled-tasks> 


4.在线Cron表达式生成器:http://www.bejson.com/cronCreator/