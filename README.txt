Pizza order SAP and ActivitiBPM process example application (3.3)
-----------------------------------------------------------------

1. Introduction
---------------

This simple example shows a simple implementation of a pizza order
management application, interacting with the ActivitiBPM engine for
user task coordination, fetching customer details from SAP, exposing a
SOAP web service frontend interface and storing state information on a
SQLServer relational database.

The example application exposes two SOAP webservices, one to place
pizza orders and the other to query the status of a specific pizza
order. 

Upon the reception of a pizza order request, the application searches
for the customer details (by name) on a SAP instance invoking the
BAPI_CUSTOMER_FIND function. Then, invokes a SQLServer stored
procedure to save the order tracking information and generate the
order number. Finally, a BPM process is started on ActivitiBPM using
the REST API, to coordinate the confirmation or rejection of the order
and its delivery through user tasks.

The user "supervisor" should perform the task of confirming orders
using the ActivitiBPM explorer UI. If the order is confirmed, the
ActivitiBPM process sends a REST message to the mule application,
starting the order confirmed flow. In this flow, the application
updates the order status on the database table and sends an email
message to the customer indicating that the order was confirmed.
Later, a user task to deliver the order is assigned to the
"deliveryboy" user. When this task is executed, ActivitiBPM sends a
message again to mule, to update the order status. The same thing
happens if the order is rejected on the first place.

After placing an order, the pizza order service will return the order
id (if the order has been placed successfully, i.e.: the customer
exists in SAP and the order details are complete). At any moment after
placing the order you can use the order status service to query the
order status, just using the order id.  

The example application shows how to effectively decouple
human-interacting tasks from integration workflows. The user-facing
side of the process is delegated to a fully-blown BPM engine, while
Mule is responsible of the integration/orchestration workload.
 
This application requires a SAP instance and the JCO SAP native and
java libraries.

Ask questions or report problems at <jesus.deoliveira@mulesoft.com>


2. How to run the example 
---------------------

* Import the project into MuleStudio (3.3), by going to the
  File->Import menu, and selecting "General->Existing project into workspace".

* Download activiti-5.10:
  http://activiti.org/downloads/activiti-5.10.zip

* Unpack activiti-5.10 zip and start the ActivitiBPM engine demo instance by
  going to the "setup" folder and running "ant demo.start". This will
  download and install the required components to run the
  ActivitiExplorer (GUI) and the ActivitiBPM engine. Make sure you're
  not running any other service on TCP port 8080 before starting the
  ActivitiBPM demo.

* Install the Jersey JAR files on activiti: Go to the tomcat
  installation on the ActivitiBPM folder, under
  "apps/apache-tomcat-6.0.32". Take the jar files found on the 
  MuleStudio project, on the folder
  src/test/resources/activiti-project/lib, and drop them on the lib
  folder of tomcat.

* Restart the ActivitiBPM engine, by running "ant demo.stop" and "ant
  demo.start" on the "setup" folder of ActivitiBPM.

* Install ActivitiDesigner on an Eclipse instance, by adding the
  update site: http://activiti.org/designer/update (Go to Help->Install
  new software and enter the update site address on the Work with
  combobox. Then select the Activiti Eclipse BPMN 2.0 Designer item on
  the results list and follow the wizard).

* Import the Activiti project found on MuleStudio,
  src/test/resources/activiti-project, on Eclipse. You'll find the pizza
  process diagram under src/main/resources/diagrams/pizzaProcess.bpmn.

* Login to the ActivitiExplorer going to
  "http://localhost:8080/activiti-explorer", using "kermit" as the
  username and "kermit" as the password.

* Create the users "supervisor" and "deliveryboy" going to Manage->Users.

* Deploy the pizza process archive, located on the Activiti project
  under the "deployments" folder (file pizzaProcess.bar), going to
  Manage->Deployments->Upload new on the activiti explorer.

* Create a SQLServer database, using the DDL script located on
  MuleStudio, on the src/main/resources/ddl.sql file. This will create
  the orders table and the create order stored procedure.

* Confirm the configuration parameters in
  src/main/resources/db.properties (database connectivity),
  src/main/resources/gmail.properties (email connectivity) and
  sap.properties (sap instance connectivity), on the MuleStudio project.

* Add the SAP JCO native libraries and jar files on the MuleStudio 
  project under the src/main/app/lib folder. Add the jar files to the
  Build path (right click on each jar file and select Build Path->Add to
  build path)

* Start the mule application, right clicking on the project on
  MuleStudio, and clicking on Run As -> Mule Application.

* Open the SOAP UI project located on
  src/test/resources/soapui-project and send a request to the Mule web
  service.

* Go to the ActivitiExplorer, login as "supervisor"
  user and observe the available tasks on the Task section. Claim the
  task and then confirm or reject it by selecting the appropriate
  outcome on the task form and clicking the "Complete task" button.

* Check that you received the confirmation email if you confirmed the
  order.

* If you confirmed the order, login again as the "deliveryboy" on the 
  ActivitiExplorer and claim and complete the deliver order task.

* Check at any moment the order status by sending a order status
  request from the SOAP UI project, using the order id. After delivering
  the order, the order status should be "Delivered".


3. Resources and additional info 
--------------------------------

* Info about ActivitiBPM process engine: http://activiti.org/

* Mule can also run an embedded instance of JBPM 4 process engine:
  http://www.mulesoft.org/documentation/display/MULE3USER/BPM+Module+Reference

* Reference documentation about the Mule SAP Connector:
  http://blogs.mulesoft.org/mule-sap-enterprise-connector-is-here/
  http://www.mulesoft.org/documentation/display/MULE3STUDIO/SAP+Endpoint+Reference
  http://www.mulesoft.org/documentation/display/MULE3USER/MuleSoft+Enterprise+Java+Connector+for+SAP+Reference
