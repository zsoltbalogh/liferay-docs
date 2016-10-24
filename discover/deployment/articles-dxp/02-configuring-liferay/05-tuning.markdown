#Liferay Digital Enterprise Configuration and Tuning Guidelines

When tuning Digital Enterprise installation, there are several factors to take into consideration,  some specific to Liferay Digital Enterprise, while others are concepts that apply to all Java and  Java enterprise applications. The following guidelines are meant to serve as an initial baseline from which to tune your specific deployment.

##Application Server Tuning

Although the actual setting names may differ, the concepts are applicable across most  application servers. We will use Tomcat as an example to demonstrate application server  tuning concepts. You should also consult your application server provider's documentation  for additional specific settings that they may advise.

###Database Connection Pool

The database connection pool is generally sized at roughly 30-40% of the thread pool size. The connection pool provides a connection whenever Digital Enterprise needs to retrieve data from the database (e.g. user login, etc). If this size is too small, requests will queue in the server waiting for database connections. However, too large a setting will mean wasting resources with idle database connections

As with thread pools, you should monitor these settings and adjust them based on your performance tests.

####Tomcat 8.0.x

In Tomcat, the connection pools are configured in the Resource elements in ``$CATALINA_HOME/conf/ Catalina/localhost/ROOT.xml``. Liferay Engineering used the following configuration during testing:

    <Resource auth=�Container�         
        description=�Digital Enterprise DB Connection�   
        driverClass=�com.mysql.jdbc.Driver�   
        maxPoolSize=�75�   minPoolSize=�10�           
        acquireIncrement=�5�   
        name=�jdbc/LiferayPool�  
        user=�XXXXXX�   
        password=�XXXXXXXXX�           
        factory=�org.apache.naming.factory.BeanFactory�
        type=�com.mchange.v2.c3p0.ComboPooledDataSource�
        jdbcUrl=�jdbc:mysql://someServer:3306/liferay_dxp?useUnicode=true
        &amp;characterEncoding=UTF-8&amp;useFastDateParsing=false�/>
    
In this configuration, we start with 10 threads, and increment by 5 as needed to a maximum of 75 connections in the pool.

You may choose from a variety of database connection pool providers, including DBCP, C3P0, HikariCP and Tomcat. You may also choose to configure the Liferay JDBC settings in your portal.properties.

###Deactivate Development Settings in the JSP Engine

Most application servers have their JSP Engine configured for development mode. Liferay recommends deactivating many of these settings prior to entering production:

* **Development mode:** This will enable the JSP container to poll the file system for changes to JSP files.
* **Mapped File:** Generates static content with one print statement versus one statement per line of JSP text.

####Tomcat 8.0.x

In the ``$CATALINA_HOME/conf/web.xml``, update the JSP servlet to look like the following:

    <servlet>   
        <servlet-name>jsp</servlet-name>
        <servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>   
        <init-param>    
            <param-name>development</param-name>    
            <param-value>false</param-value>   
        </init-param>   
        <init-param>    
            <param-name>mappedFile</param-name>    
            <param-value>false</param-value>   
        </init-param>   
        <load-on-startup>3</load-on-startup> 
    </servlet>

###Thread Pool

Each incoming request to the application server consumes a worker thread for the duration of  the request. When no threads are available to process requests, the request will be queued waiting for the next available worker thread. In a finely tuned system, the number of threads in the thread pool should be relatively balanced with the total number of concurrent requests. There should not be a significant amount of threads left idle waiting to service requests. 

Liferay Engineering recommends setting this initially to 50 threads and then monitoring it within your application server�s monitoring consoles. You may wish to use a higher number (e.g., 250) if your average page times are in the 2-3s range. Too few threads in the thread pool may lead to excessive request queuing while too many threads may lead to excessive context switching.

####Tomcat 8.0.x

In Tomcat, the thread pools are configured in the Connector element in ``$CATALINA_HOME/conf/server.xml``. Further information can be found in the [Apache Tomcat documentations](https://tomcat.apache.org/tomcat-8.0-doc/config/http.html). Liferay Engineering used the following configuration during testing:

    <Connector maxThreads=�75� minSpareThreads=�50� 
        maxConnections=�16384� port=�8080�     
        connectionTimeout=�600000� redirectPort=�8443� 
        URIEncoding=�UTF-8�  socketBuffer=�-1�     
        maxKeepAliveRequests=�-1� address=�xxx.xxx.xxx.xxx�/>
        
Additional tuning parameters around Connectors are available, including the connector types,  the connection timeouts and TCP queue. You should consult the appropriate Tomcat documentation for further details.

##Java Virtual Machine Tuning

Tuning the JVM primarily focuses on tuning the garbage collector and the Java memory heap. These parameters look to optimize the throughput of your application. We used Oracle's 1.8 JVM for the reference architecture. You may also choose other supported JVM versions and implementations. Please consult the [Liferay Digital Enterprise Compatibility Matrix](https://web.liferay.com/group/customer/dxp/support/compatibility-matrix) for additional compatible JVMs.

###Garbage Collector

Choosing the appropriate garbage collector (GC) will help improve the responsiveness of your Liferay Digital Enterprise deployment. Liferay recommends using the concurrent low pause collectors:

    -XX:+UseParNewGC -XX:ParallelGCThreads=16 -XX:+UseConcMarkSweepGC 
    -XX:+CMSParallelRemarkEnabled -XX:+CMSCompactWhenClearAllSoftRefs
    -XX:CMSInitiatingOccupancyFraction=85 -XX:+CMSScavengeBeforeRemark
    
You may choose from other available GC algorithms including parallel throughput collectors and G1 collectors. Liferay recommends first starting your tuning using parallel collectors in the new generation and concurrent mark sweep (CMS) in the old generation.

**Note:** the value 16 in ``ParallelGCThreads=16`` will vary based on the type of CPUs available. We recommend setting the value according to CPU specification. On Linux machines, you may find the number of available CPUs by running ``cat/proc/cpuinfo``.

**Note:** There are additional �new� algorithms like G1, but Liferay Engineering's tests for G1 have indicated that it does not improve performance. Your application performance may vary and you should add it to your testing and tuning plans.

###Code Cache

Java uses a just-in-time (JIT) compiler to generate native code to improve performance. The default size is 48M. This may not be sufficient for larger applications. Too small a code cache will reduce performance as the JIT would not be able to optimize high frequency methods. For Digital Enterprise, we recommend starting with 64M for the initial code cache size.

    -XX:InitialCodeCacheSize=32m -XX:ReservedCodeCacheSize=96m
    
You can examine the efficacy of the parameter changes by adding the following parameters:

    -XX:+PrintCodeCache -XX:+PrintCodeCacheOnCompilation

###Java Heap

When most people think about tuning the Java memory heap, they think of setting the maximum and  minimum memory of the heap. Unfortunately, most deployments require far more sophisticated heap  tuning to obtain optimal performance, including tuning the young generation size, tenuring durations, survivor spaces and many other JVM internals.

For most systems, Liferay recommends starting with at least the following memory settings:

    -server -XX:NewSize=700m -XX:MaxNewSize=700m -Xms2048m -Xmx2048m -XX:MetaspaceSize=300m 
    -XX:MaxMetaspaceSize=300m -XX:SurvivorRatio=6 �XX:TargetSurvivorRatio=9 �XX:MaxTenuringThreshold=15

On systems that require large heap sizes (e.g., above 4GB), it may be beneficial to use large page sizes. 
You may activate large page sizes using the following JVM options:

    -XX:+UseLargePages -XX:LargePageSizeInBytes=256m
    
You may choose to specify different page sizes based on your application profile.

**Note:** To use large pages in the JVM, you must configure your underlying operation system to activate them. In Linux, run ``cat/proc/meminfo`` and look at �huge page� items

* **Caution:** You should avoid allocating more than 32GB to your JVM heap. Your heap size should be commensurate with the speed and quantity of available CPU resources.

###JVM Advanced Options

The following advanced JVM options were also applied in the Liferay benchmark environment:

    -XX:+UseLargePages -XX:LargePageSizeInBytes=256m 
    -XX:+UseCompressedOops -XX:+DisableExplicitGC -XX:-UseBiasedLocking 
    -XX:+BindGCTaskThreadsToCPUs -XX:UseFastAccessorMethods

Please consult your JVM documentation for additional details on advanced JVM options.

Combining the above parameters together, we have:

    -server -XX:NewSize=1024m -XX:MaxNewSize=1024m -Xms4096m 
    -Xmx4096m -XX:MetaspaceSize=300m -XX:MaxMetaspaceSize=300m 
    -XX:SurvivorRatio=12 �XX:TargetSurvivorRatio=90 
    �XX:MaxTenuringThreshold=15 -XX:+UseLargePages 
    -XX:LargePageSizeInBytes=256m -XX:+UseParNewGC 
    -XX:ParallelGCThreads=16 -XX:+UseConcMarkSweepGC 
    -XX:+CMSParallelRemarkEnabled -XX:+CMSCompactWhenClearAllSoftRefs
    -XX:CMSInitiatingOccupancyFraction=85 -XX:+CMSScavengeBeforeRemark 
    -XX:+UseLargePages -XX:LargePageSizeInBytes=256m 
    -XX:+UseCompressedOops -XX:+DisableExplicitGC -XX:-UseBiasedLocking 
    -XX:+BindGCTaskThreadsToCPUs -XX:+UseFastAccessorMethods 
    -XX:InitialCodeCacheSize=32m -XX:ReservedCodeCacheSize=96m
    
* **Caution:** The above JVM settings should formulate a starting point for your performance tuning. Each system's final parameters will vary due to a variety of factors including number of current users and transaction speed.

Liferay recommends monitoring the garbage collector statistics to ensure your environment  has sufficient allocations for metaspace and also for the survivor spaces. Simply using the guideline numbers above may results in dangerous runtime scenarios like out of memory failures. Improperly tuned survivor spaces also lead to wasted heap space.
