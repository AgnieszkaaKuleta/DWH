# DWH_kindergarten
Project was made with Kamil Dędza (https://github.com/wojozera)
# RDB 
RDB stands for Relational Database. It refers to a type of database management system (DBMS) that is based on the relational model of data organization. In a relational database, data is structured and stored in tables consisting of rows and columns. It was the main data source for our project. To create the relational database we had to think about what data we want to store, which we have to omit in our analysis. We have concluded that we do not store any data about the money flow in kindergarten, but put our main focus into the application process. After many iterations and new and new designs we have finally created the most optimal one. Keep in mind that all the primary keys need to be present, remember about foreign keys and many to many relationships. Here is how our final diagram looks like: 
![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/2fc3e1dd-9c0a-4b43-9592-661474d78a53)
 
# DATA WAREHOUSE
The primary goal of a data warehouse is to provide a reliable and optimized environment for performing complex queries and analysis on historical and current data. By organizing data in a consistent manner, data warehouses enable businesses to gain insights, identify trends, and make data-driven decisions. The design of data warehouse is one of the biggest challenges in the whole process. Keeping in mind all the rules for fact tables, dimensions and our needs it was hard to create the desired DW. Remember about the non-numeric attributes in the dimensions, measures, foreign keys in the fact tables etc. For our DW we have selected extended star schema with two fact tables, and in total 3 measures. Two of them are just simply the counts of the fact tuples and the last one is number of additional lessons selected to each application. In our design we have also added the JUNK dimension, which stores the data that is not properly connect to any of the dimensions, but is necessary for later analysis. Remember that all tuples in the DW have to unique. It is also worth to note that we do not focus on the columns in our data sources, but rather think of our needs for the later analysis and answer to specific business question. During the design think about the simplicity and making cube slicing and dicing easier in the future tasks. 

![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/44b5a8d4-a21b-4148-9534-0c6367af6ed7)

# ETL 
The ETL process stands for Extract, Transform, and Load. It is a fundamental process used in data integration to extract data from various sources, transform it into a suitable format, and load it into a target system such as a data warehouse. The main purposes of the ETL process are as follows:
Extraction: In this stage, data is extracted from multiple source systems, which can include databases, flat files, APIs, web services, or other structured and unstructured data sources. The extraction process involves identifying the relevant data sets needed for analysis or reporting.
Transformation: Once the data is extracted, it goes through a series of transformations to convert it into a consistent and usable format for analysis and storage. Data transformation involves activities like data cleansing, data validation, data aggregation, data normalization, data enrichment, and applying business rules or calculations. This stage ensures that the data is accurate, consistent, and aligned with the desired structure.
Loading: After the data has been transformed, it is loaded into the target system, which is typically a data warehouse or a data mart. The loading process involves populating the target database with the transformed data, ensuring it is properly structured and organized according to the data model of the target system.
# Date dimension
Time is one of the most important dimension in many DW. How to create proper rows according to each day or each hour? The answer to that question is pretty simple. We can create while loop, inside just adding one day/hour in each iteration. Here is how it looks like in implementation. We need to declare our start and end dates and cast the values in proper format. In the example below we want all the attributes of date, meaning year, month, day to be in int type. Firstly, we need to get just the particular value of the attribute, and then cast it in the desired format. In line 28, we are moving the DateInProcess one day in the future, so are next loop will generate the next day.
 ![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/00c23271-bcbb-47df-a70a-ebd957e1fb7c)

# Unknown rows 
It is often the case that we lack of some data. But in the cube we cannot afford having null values. So what to do then? We can create fictional rows with the specific key number, usually -1 that describes the empty dimensions. At first we want to change the identity_insert to ON (because we want to turn off the auto increment). Then we simply add one row with specific key(-1) and set the other columns also to the specific values, for example -1 for int, 'UNKNOWN' for string etc. Then remember to turn the identity_insert again if needed.
![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/821ce734-9c7e-4f4c-b912-e39a9ad7b032)


# JUNK/MISCELLANOUS DIMENSION
Sometimes we have some attributes that do not connect with any of the dimensions, usually in the form of flags for example yes/no, positive/negative etc. But how to generate all the possible values for these columns?  The SELECT statement following the INSERT INTO statement retrieves the data that will be inserted into the [DIM_JUNK] table. The data is sourced from a set of four separate subqueries, each using the VALUES clause to create a virtual table with specific values.
 ![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/1f57087f-4839-463b-b66c-ec5f1adae73d)

# SCD2 
In SCD Type 2, when a new record is encountered in the source data that represents a change in a dimension's attributes, a new row is inserted into the dimensional table to capture the updated values. The existing row is then marked with an end date, indicating when it became inactive. This approach ensures that both the old and new versions of the data are preserved and available for analysis. It sounds a little bit complicated, but in reality with proper ideas and implemention it is quite pleasant. What we need to have before start of our SCD2 implementation is: surrogate key, natural business key and columns for storing the start date, end date and optionally place for storing the flag active/inactive. All the magic happens inside the hopefully well known MERGE statement. If our key(remember to check natural business key, not suragate!) is not present in the target dimension table, we simply add it. That is what we usually do without SCD2 implementation in MERGE statement. But now we also have the second condition which is when the natural business key is matched and flag for SCD2 is set to no/inactive and one of the changing dimensions actually changed. That means that we have encountered our old tuple, so we need to set the proper date and proper flag using SET command.
 ![image](https://github.com/AgnieszkaaKuleta/DWH_kindergarden_project/assets/129444728/b0b1920a-1826-4cb7-9dfe-0685fcdfae30)

Then what is important to our actual table we want to add only new tuples and those which changed. To do that we can use the SELECT statement combined with the EXCEPT. This code inserts new records into the DIM_facility table by selecting records from the view_facility view that do not already exist in DIM_facility. This approach helps to prevent duplicate records and ensures that only new and unique records are inserted into the target table.
 
 
# DIMENSIONS AND FACTS LOADING
We have created different files for each dimension/measure of our DW. The most common technique was to first create the view, where we can do all the transformations needed, and then fill actual tables. To do that, at first we are checking whether the view exist. If it indeed exists, we drop it to make the view clear.
 
Then it is time to take the data from the RDB to our view using select statement. Some of the columns are ready immediately, some need some transformation. In the dimension contract we can take a look at the at the second column in the view called [c2]. Using CASE statement we can transform our data in a desired way, so checking whether the today's date is between the day of isuue of the contract and its ending day then we can state that the contract is active, other way it is inactive.
 
When our view is ready and looks like the desired dim table we are ready to put it to the actual table. In handy comes the MERGE statement, which combines the functionality of both INSERT and UPDATE statements. It allows you to efficiently synchronize data between a source table(view view_contract) and a target table(dimension DIM_contract) based on a specified condition, known as the merge condition. The merge condition determines whether a row from the source table should be inserted into the target table or updated if it already exists.
 
As you can see the merge condition in our case is WHEN NOT MATCHED. It means that if target table does not contain the specific key it should be inserted. 
Sometimes it is neccesarry to combine several tables, different data sources into the way table in DW. Example with DIM_contract was pretty basic and without any issues. Here you can see how to combine data from the CSV file and many tables from RDB into the one table in the DW.
Firstly we need to get the data from the CSV file into the table. To do that we create table with needed columns.
 
Then we need to fill it with the appriopriate data(remember about proper path to the file).
FIRSTROW parameter states where the actual data starts(sometimes we want to omit first row because it contain tittles), FIELDTERMINATOR states with which character our columns are seprated, ROWTERMINATOR the same as with field, but about the endline.
 
The we move on to creating the view which join two tables - application and the one we created above. You can also see bunch of case statement, hopefully easy to follow(there is a typo in word SIGNEN - we meant SIGNED obviously)
 
Do not hesitate to create many views if it is necessary or convient. Here is another view used in creating FACT_application. As you can see we have also used GROUP BY and COUNT function to create the data that suits our needs.
 
The final view creation looks a little bit scary. In fact it just checking whether in the dimension we should use the UNKNOWN rows, or proper data by using IS NOT NULL statement. Function ISNULL() can also come in handy. Then there is a bunch of LEFT JOIN statement, because we do not want to take the cartesian product of all possible combinations. In line 108 we are handling the slowly changing dimensions. If the natural key is the same - facility name and the SCDcurrent column is equal to 'YES', because we want our fact to be connected to the active tuple from the changed dimension, not the old one. It is the most import part in that piece of code. At the end we are comparing the dates, so we need to remember about proper conversion using YEAR, MONTH and DATE functions.
 
Then, as usual using MERGE we can conduct filling the data to the FACT_application in this case.
 
Visualisations: data_visual - Strona główna (sharepoint.com)
